class Subscription < ApplicationRecord
  belongs_to :plan, inverse_of: :subscriptions
  belongs_to :subscriber, inverse_of: :subscription, class_name: 'User'

  validates_presence_of :plan_id, :subscriber_id

  scope :active, -> { with_status :active }

  state_machine :status, initial: :initial do
    state :initial
    state :active
    state :canceled

    after_transition canceled: :active do |subscription|
      subscription.update_column(:canceled_on, nil)
    end

    after_transition any => :canceled do |subscription|
      subscription.update(
        canceled_on: Time.zone.today,
        scheduled_for_cancellation_on: nil
      )
    end

    event :activate do
      transition [:initial, :canceled] => :active
    end

    event :cancel do
      transition active: :canceled
    end
  end

  delegate :stripe_customer_id, to: :subscriber
  delegate :interval_count, :interval_unit, :price, :stripe_plan_id, to: :plan

  attr_accessor :stripe_coupon_id, :stripe_token

  def fulfill
    transaction do
      create_subscription
      activate
    end
  end

  def coupon
    @coupon ||= Coupon.new(stripe_coupon_id)
  end

  def has_invalid_coupon?
    stripe_coupon_id.present? && !coupon.valid?
  end

  def scheduled_for_cancellation?
    scheduled_for_cancellation_on.present?
  end

  def reactivate
    update_column(:scheduled_for_cancellation_on, nil)
    stripe_subscription.reactivate
  end

  private

  def create_subscription
    if create_stripe_subscription && save
      self.stripe_subscription_id = stripe_subscription.id
    end
  end

  def create_stripe_subscription
    stripe_subscription.create
  end

  def stripe_subscription
    @stripe_subscription ||= StripeSubscription.new(self)
  end
end
