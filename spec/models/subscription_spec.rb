require 'spec_helper'

describe Subscription, type: :model do
  describe 'validations' do

    it 'validates and associates with' do
      is_expected.to belong_to :plan
      is_expected.to belong_to :subscriber
    end
  end

  describe '#activate' do
    it 'updates the subscription record by setting the status to "active"' do
      subscription = create :subscription, status: 'initial'

      subscription.activate
      subscription.reload

      expect(subscription.status).to eq 'active'
    end
  end

  describe '#cancel' do
    it 'updates the subscription record by setting the status to "canceled"' do
      s1 = create :active_subscription, plan_id: 1
      s2 = create :active_subscription, plan_id: 2

      s1.cancel
      s2.cancel
      s1.reload
      s2.reload

      result = Subscription.with_status('canceled')

      expect(result.map(&:id)).to match_array(Subscription.ids)
    end
  end

  describe '#reactivate' do
    it 'clears the scheduled_for_cancellation_on field' do
      subscription = create(
        :subscription,
        scheduled_for_cancellation_on: Date.today
      )
      fake_subscription = spy(plan: double(id: 'plan'))
      allow(subscription).
        to receive(:stripe_subscription).
        and_return(fake_subscription)

      subscription.reactivate

      expect(subscription.scheduled_for_cancellation_on).to be_nil
    end
  end

  describe '#scheduled_for_cancellation?' do
    it 'returns false if scheduled_for_cancellation_on is nil' do
      subscription = Subscription.new(scheduled_for_cancellation_on: nil)

      expect(subscription).not_to be_scheduled_for_cancellation
    end

    it 'returns true if scheduled_for_cancellation_on is not nil' do
      subscription = Subscription.new(
        scheduled_for_cancellation_on: Time.zone.today
      )

      expect(subscription).to be_scheduled_for_cancellation
    end
  end
end
