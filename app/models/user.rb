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

  has_many :enrollments, inverse_of: :student, foreign_key: 'student_id'
  has_many :courses_as_student, through: :enrollments, inverse_of: :students, class_name: 'Course'
  has_many :courses_as_instructor, inverse_of: :instructor, class_name: 'Course', foreign_key: :instructor_id
  has_many :enrolled_lessons, inverse_of: :student, foreign_key: 'student_id'
  has_many :lessons, through: :enrolled_lessons, inverse_of: :students
  has_many :uploads, inverse_of: :user
  has_many :charges, inverse_of: :user

  has_one :subscription, inverse_of: :subscriber, foreign_key: 'subscriber_id'
  has_one :plan, through: :subscription, inverse_of: :subscribers

  has_many :purchases, inverse_of: :purchaser, foreign_key: :purchaser_id
  has_many :courses, through: :purchases, inverse_of: :purchasers, source: :purchasable, source_type: 'Course'

  before_save :skip_confirmation_notification, on: :create
  after_create :assign_default_role

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
    self.purchases.where(purchasable_id: resource.id, purchasable_type: resource.class.to_s).present?
  end

  def subscribed?
    self.subscription.present? && self.subscription.active?
  end

  def braintree_customer?
    self.braintree_customer_id
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :name, :full_name

  def init_braintree_customer(payment_method_nonce)
    if !braintree_customer?
      result = Braintree::Customer.create(
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
      if result.success?
        payment_method = result.customer.payment_methods.find{ |pm| pm.default? }

        self.braintree_customer_id = result.customer.id
        self.braintree_payment_method = payment_method.class.to_s.gsub(/^.*::/, '')
        self.paypal_email = payment_method.try(:email)
        self.card_type = payment_method.try(:card_type)
        self.card_last4 = payment_method.try(:last_4)
        self.card_exp_month = payment_method.try(:expiration_month)
        self.card_exp_year = payment_method.try(:expiration_year)
        self.save
        true
      else
        false
      end
    end
  end

  def init_braintree_payment_method(payment_method_nonce)
    if braintree_customer?
      result = Braintree::PaymentMethod.create(
        customer_id: self.braintree_customer_id,
        payment_method_nonce: payment_method_nonce,
        options: {
          fail_on_duplicate_payment_method: true,
          make_default: true,
          verify_card: true
        }
      )

      payment_method = result.payment_method

      if result.success?
        self.braintree_payment_method = payment_method.class.to_s.gsub(/^.*::/, '')
        self.paypal_email = payment_method.try(:email)
        self.card_type = payment_method.try(:card_type)
        self.card_last4 = payment_method.try(:last_4)
        self.card_exp_month = payment_method.try(:expiration_month)
        self.card_exp_year = payment_method.try(:expiration_year)
        self.save
        true
      else
        false
      end

    else
      self.init_braintree_customer(payment_method_nonce)
    end
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

end
