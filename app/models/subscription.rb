class Subscription < ApplicationRecord
  belongs_to :plan, inverse_of: :subscriptions
  belongs_to :subscriber, inverse_of: :subscription, class_name: 'User'

  validates_presence_of :plan_id, :subscriber_id

  scope :active, -> { with_status :active }

  state_machine :status, initial: :initial do
    state :initial
    state :active
    state :suspended
    state :canceled

    event :activate do
      transition [:initial, :suspended, :canceled] => :active
    end

    event :suspend do
      transition active: :suspended
    end

    event :cancel do
      transition [:active, :suspended] => :canceled
    end
  end

  delegate :stripe_plan_id, to: :plan, prefix: false

  attr_accessor :stripe_token

  def fulfill
    transaction do
      create_subscription
      activate
    end
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
