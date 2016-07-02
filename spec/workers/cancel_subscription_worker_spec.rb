require 'spec_helper'

describe CancelSubscriptionWorker, sidekiq: :inline do

  before { allow(CancelSubscriptionWorker).to receive(:perform_in) }

  let(:user) { create :user }
  let(:u2) { create :user }
  let(:plan) { create :plan }
  let(:s1) { create :subscription, subscriber: user, plan: plan, braintree_subscription_id: 1 }
  let(:s2) { create :subscription, subscriber: u2, plan: plan, braintree_subscription_id: 2 }

  before do
    init_braintree_customer
    init_braintree_subscription
  end

  context '#cancel_subscription', sidekiq: :inline do
    it 'cancels existing subscription' do
      CancelSubscriptionWorker.perform_async(user.id, s1.braintree_subscription_id)
      subscription = Braintree::Subscription.find(s1.braintree_subscription_id)
      expect(subscription.status).to eq 'Canceled'
      user.subscription.reload
      expect(user.subscription.status).to eq 'canceled'
    end
  end

  context 'scheduling new worker', sidekiq: :fake do
    context 'when worker exists' do
      before { CancelSubscriptionWorker.perform_async(user.id, s1.id) }

      context 'not unique' do
        subject { -> { CancelSubscriptionWorker.perform_async(user.id, s1.id) } }

        it { is_expected.not_to change(CancelSubscriptionWorker.jobs, :size) }
      end

      context 'unique' do
        subject { -> { CancelSubscriptionWorker.perform_async(u2.id, s2.id) } }

        it { is_expected.to change(CancelSubscriptionWorker.jobs, :size).by(1) }
      end
    end
  end
end
