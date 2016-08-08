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

  describe '#suspend' do
    it 'updates the subscription record by setting the status to "suspended"' do
      subscription = create :subscription, status: 'active'

      subscription.suspend
      subscription.reload

      expect(subscription.status).to eq 'suspended'
    end
  end

  describe '#cancel' do
    it 'updates the subscription record by setting the status to "canceled"' do
      s1 = create :subscription, status: 'active', plan_id: 1
      s2 = create :subscription, status: 'suspended', plan_id: 2

      s1.cancel
      s2.cancel
      s1.reload
      s2.reload

      result = Subscription.with_status('canceled')

      expect(result.map(&:id)).to match_array(Subscription.ids)
    end
  end

end
