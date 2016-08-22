require 'spec_helper'

describe Cancellation do
  it 'should be ActiveModel-compliant' do
    cancellation = build_cancellation

    expect(cancellation).to be_a(ActiveModel::Model)
  end

  describe '#process' do
    before :each do
      allow(subscription).to receive(:stripe_customer_id).
        and_return('cus12345')
    end

    context 'with an active subscription' do
      it 'makes the subscription inactive and records the current date' do
        cancellation.process

        expect(subscription.canceled_on).to eq Time.zone.today
      end
    end
  end

  describe '#schedule' do
    it 'schedules a cancellation with Stripe' do
      Timecop.freeze(Time.current) do
        cancellation = build_cancellation(subscription: subscription)
        allow(Stripe::Customer).to(
          receive(:retrieve).and_return(stripe_customer),
        )

        cancellation.schedule

        subscription.reload
        expect(stripe_customer.subscriptions.first).
          to have_received(:delete).with(at_period_end: true)
        expect(subscription.scheduled_for_cancellation_on).
          to eq Time.zone.at(billing_period_end).to_date
        expect(analytics).to have_tracked('Cancelled subscription').
          for_user(subscription.subscriber)
      end
    end

    it 'returns true when valid' do
      cancellation = build_cancellation
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)

      expect(cancellation.schedule).to eq true
    end

    it 'retrieves the customer correctly' do
      cancellation = build_cancellation(subscription: subscription)

      allow(subscription).to receive(:stripe_customer_id).
        and_return('cus12345')
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      cancellation.schedule

      expect(Stripe::Customer).to have_received(:retrieve).
        with('cus12345')
    end

    it 'does not make the subscription inactive if stripe unsubscribe fails' do
      cancellation = build_cancellation(subscription: subscription)
      allow(stripe_customer.subscriptions.first).to receive(:delete).
        and_raise(Stripe::StripeError)
      allow(Stripe::Customer).to receive(:retrieve).
        and_return(stripe_customer)
      allow(Analytics).to receive(:new)

      expect { cancellation.schedule }.to raise_error(Stripe::StripeError)
      expect(subscription.reload).to be_active
      expect(Analytics).not_to have_received(:new)
    end
  end

  describe '#subscribed_plan' do
    it 'returns the plan from the subscription' do
      subscription = build_stubbed(:subscription)
      cancellation = build_cancellation(subscription: subscription)

      expect(cancellation.subscribed_plan).to eq(subscription.plan)
    end
  end

  def build_cancellation(subscription: create(:subscription))
    Cancellation.new(
      subscription: subscription
    )
  end

  def subscription
    @subscription ||= create(:active_subscription)
  end

  def cancellation
    @cancellation ||= build_cancellation(subscription: subscription)
  end

  def stripe_customer
    @stripe_customer ||= double(
      'Stripe::Customer',
      subscriptions: [
        double(
          'Subscription',
          current_period_end: billing_period_end,
          delete: true
        )
      ]
    )
  end

  def billing_period_end
    1361234235
  end
end
