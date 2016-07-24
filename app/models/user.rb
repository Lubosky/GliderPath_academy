class User < ApplicationRecord
  rolify
  devise  :confirmable,
          :database_authenticatable,
          :lockable,
          :registerable,
          :recoverable,
          :rememberable,
          :trackable,
          :validatable
          # :timeoutable, :omniauthable

  validates_presence_of :first_name, :last_name
  validates_length_of :headline, maximum: 80
  validates_length_of :bio, maximum: 800

  has_many :enrollments, inverse_of: :student, foreign_key: :student_id
  has_many :courses_as_student, through: :enrollments, inverse_of: :students, class_name: 'Course'
  has_many :courses_as_instructor, inverse_of: :instructor, class_name: 'Course', foreign_key: :instructor_id
  has_many :enrolled_lessons, inverse_of: :student, foreign_key: :student_id
  has_many :lessons, through: :enrolled_lessons, inverse_of: :students
  has_many :uploads, foreign_key: :uploader_id
  has_many :charges, inverse_of: :user

  has_one :subscription, inverse_of: :subscriber, foreign_key: :subscriber_id
  has_one :plan, through: :subscription, inverse_of: :subscribers

  has_many :purchases, inverse_of: :purchaser, foreign_key: :purchaser_id
  has_many :courses, through: :purchases, inverse_of: :purchasers, source: :purchasable, source_type: 'Course'

  before_save :skip_confirmation_notification, on: :create
  after_create :assign_default_role

  attachment :avatar, type: :image

  def assign_default_role
    add_role(:student)
  end

  def enroll(course)
    self.enrollments.create(course_id: course.id)
  end

  def enrolled?(course)
    self.enrollments.where(course_id: course.id).present?
  end

  def purchased?(resource)
    self.purchases.where(purchasable: resource).present?
  end

  def has_active_subscription?
    self.subscription.present? && self.subscription.active?
  end

  def has_suspended_subscription?
    self.subscription.present? && self.subscription.suspended?
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :name, :full_name

  def braintree_customer?
    self.braintree_customer_id
  end

  def init_braintree_client_token
    if braintree_customer?
      Braintree::ClientToken.generate(customer_id: self.braintree_customer_id)
    else
      Braintree::ClientToken.generate
    end
  end

  def ensure_customer_exists(payment_method_nonce)
    if braintree_customer?
      self.update_payment_method(payment_method_nonce)
    else
      self.create_customer(payment_method_nonce)
    end
  end

  def update_payment_method(payment_method_nonce)
    UpdatePaymentMethodWorker.perform_async(self.id, payment_method_nonce)
  end

  def create_customer(payment_method_nonce)
    if !braintree_customer?
      result = create_braintree_customer(payment_method_nonce)
      if result.success?
        payment_method = default_payment_method(result.customer)
        update_with_braintree_data(result.customer.id, payment_method)
        true
      else
        false
      end
    end
  end

  def create_subscription(plan)
    result = create_braintree_subscription(plan)
    if result.success?
      self.confirm unless self.confirmed?
      subscription = Subscription.where(subscriber_id: self.id).first_or_initialize
      subscription.update(braintree_subscription_id: result.subscription.id, subscriber_id: self.id, plan_id: plan.id) && subscription.activate
      true
    else
      false
      self.send_confirmation_instructions unless self.confirmed?
    end
  end

  def create_purchase(product)
    result = create_braintree_purchase(product.price)
    if result.success?
      self.confirm unless self.confirmed?
      self.purchases.create(braintree_purchase_id: result.transaction.id, purchaser_id: self.id, purchasable_id: product.id, purchasable_type: product.class)
      CreateChargeWorker.perform_async(self.id, result.transaction.id, product.name)
      true
    else
      false
      self.send_confirmation_instructions unless self.confirmed?
    end
  end

  def update_with_braintree_data(customer_id, payment_method)
    self.braintree_customer_id = customer_id
    self.braintree_payment_method_attributes(payment_method)
    self.save
  end

  def cancel_subscription
    unless !has_active_subscription?
      CancelSubscriptionWorker.perform_async(self.id, self.subscription.braintree_subscription_id)
    end
  end

  def create_braintree_customer(payment_method_nonce)
    Braintree::Customer.create(
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      payment_method_nonce: payment_method_nonce,
      credit_card: {
        options: {
          verify_card: true
        }
      }
    )
  end

  def create_braintree_payment_method(payment_method_nonce)
    Braintree::PaymentMethod.create(
      customer_id: self.braintree_customer_id,
      payment_method_nonce: payment_method_nonce,
      options: {
        fail_on_duplicate_payment_method: true,
        make_default: true,
        verify_card: true
      }
    )
  end

  def create_braintree_subscription(plan)
    Braintree::Subscription.create(
      payment_method_token: default_payment_method(braintree_customer).token,
      plan_id: plan.braintree_plan_id
    )
  end

  def create_braintree_purchase(price)
    Braintree::Transaction.sale(
      payment_method_token: default_payment_method(braintree_customer).token,
      amount: price,
      options: {
        store_in_vault_on_success: true,
        submit_for_settlement: true
      }
    )
  end

  def braintree_payment_method_attributes(payment_method)
    self.braintree_payment_method = payment_method.class.to_s.gsub(/^.*::/, '')
    self.paypal_email = payment_method.try(:email)
    self.card_type = payment_method.try(:card_type)
    self.card_last4 = payment_method.try(:last_4)
    self.card_exp_month = payment_method.try(:expiration_month)
    self.card_exp_year = payment_method.try(:expiration_year)
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

    def self.current
      RequestStore.store[:current_user]
    end

    def self.current=(user)
      RequestStore.store[:current_user] = user
    end

    def skip_confirmation_notification
      skip_confirmation_notification!
    end

    def braintree_customer
      Braintree::Customer.find(self.braintree_customer_id)
    end

    def default_payment_method(braintree_customer)
      braintree_customer.payment_methods.find{ |pm| pm.default? }
    end

end
