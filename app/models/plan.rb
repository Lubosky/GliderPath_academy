class Plan < ApplicationRecord

  NAMES = %w( gliderpath_academy_monthly )

  has_many :subscriptions, inverse_of: :plan
  has_many :subscribers, through: :subscriptions, inverse_of: :plan, class_name: 'User'

  validates_presence_of :name
  validates :braintree_plan_id, presence: true, uniqueness: true, inclusion: NAMES
end
