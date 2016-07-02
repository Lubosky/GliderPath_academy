class Subscription < ApplicationRecord
  belongs_to :plan, inverse_of: :subscriptions
  belongs_to :subscriber, inverse_of: :subscription, class_name: 'User'

  validates_presence_of :plan_id, :subscriber_id

  scope :active, ->{ with_status :active }

  state_machine :status, initial: :initial do
    state :initial
    state :active
    state :canceled

    event :activate do
      transition [ :initial, :canceled ] => :active
    end

    event :cancel do
      transition active: :canceled
    end
  end
end
