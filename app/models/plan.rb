class Plan < ApplicationRecord

  NAMES = %w(gliderpath_academy_monthly).freeze

  has_many :subscriptions, inverse_of: :plan
  has_many :subscribers, through: :subscriptions, inverse_of: :plan, class_name: 'User'

  validates_presence_of :name
  validates :stripe_plan_id, presence: true, uniqueness: true, inclusion: NAMES

  def price
    cents_to_dollars(stripe_plan.amount.to_f)
  end

  def interval_unit
    stripe_plan.interval
  end

  def interval_count
    stripe_plan.interval_count
  end

  private

  def cents_to_dollars(amount)
    amount / 100
  end

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(stripe_plan_id)
  end
end
