require 'spec_helper'

describe StripeEvents do
  describe '#customer_subscription_deleted' do
    it 'sends notifications if no subscription is found' do
      allow(Rollbar).to receive(:error)

      StripeEvents.new(event).customer_subscription_deleted

      expect(Rollbar).to have_received(:error).once
    end

    it 'cancels plan if subscription found' do
      subscription = stub_subscription
      cancellation = spy('Cancellation')
      allow(Cancellation).to receive(:new).and_return(cancellation)

      StripeEvents.new(event).customer_subscription_deleted

      expect(Cancellation).to(
        have_received(:new).with(subscription: subscription)
      )
      expect(cancellation).to have_received(:process).once
    end
  end

  private

  def stub_subscription
    subscription = build_stubbed(:subscription)
    allow(Subscription).to receive(:find_by).and_return(subscription)
    subscription
  end

  def event
    double(
      'Event',
      data: double('Data', object: stripe_subscription),
      to_hash: {}
    )
  end

  def stripe_subscription
    double(
      'StripeSubscription',
      id: 'sub12345'
    )
  end
end
