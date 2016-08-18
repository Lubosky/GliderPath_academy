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

  has_many :charges, inverse_of: :user
  has_many :courses_as_student, through: :enrollments, inverse_of: :students, class_name: 'Course'
  has_many :courses_as_instructor, inverse_of: :instructor, class_name: 'Course', foreign_key: :instructor_id
  has_many :enrolled_lessons, inverse_of: :student, foreign_key: :student_id
  has_many :enrollments, inverse_of: :student, foreign_key: :student_id
  has_many :lessons, through: :enrolled_lessons, inverse_of: :students
  has_many :uploads, foreign_key: :uploader_id
  has_many :workshops, inverse_of: :instructor, class_name: 'Workshop', foreign_key: :instructor_id

  has_one :subscription, inverse_of: :subscriber, foreign_key: :subscriber_id
  has_one :plan, through: :subscription, inverse_of: :subscribers

  has_many :purchases, foreign_key: :purchaser_id
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

  def has_access_to?(feature)
    self.has_active_subscription? || self.purchased?(feature)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :name, :full_name

  def credit_card
    if stripe_customer?
      @credit_card ||= stripe_customer.sources.detect do |card|
        card.id == stripe_customer.default_source
      end
    end
  end

  def has_credit_card?
    stripe_customer? && stripe_customer.sources.any?
  end

  def stripe_customer?
    stripe_customer_id.present?
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

  def stripe_customer
    if stripe_customer_id.present?
      @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
    end
  end
end
