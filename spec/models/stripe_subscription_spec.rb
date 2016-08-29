require 'spec_helper'

describe StripeSubscription do
  context '#create' do
    context 'when there is an existing Stripe Customer record' do
      it "updates the user's credit card" do
        customer = stub_existing_customer

        subscription = build(
          :subscription,
          stripe_token: 'stripe_token'
        )
        stripe_subscription = StripeSubscription.new(subscription)

        stripe_subscription.create

        expect(customer).to have_received(:card=).with('stripe_token')
        expect(customer).to have_received(:save)
      end

      it "updates the customer's plan" do
        customer = stub_existing_customer

        subscription = build(:subscription, plan: create(:plan))
        stripe_subscription = StripeSubscription.new(subscription)

        stripe_subscription.create

        new_subscription = customer.subscriptions.first
        expect(new_subscription[:plan]).to eq subscription.stripe_plan_id
      end

      it 'updates the subscription with the given coupon' do
        customer = stub_existing_customer
        coupon = double('coupon', amount_off: 25)
        allow(Stripe::Coupon).to receive(:retrieve).and_return(coupon)
        subscription = build(:subscription, stripe_coupon_id: '25OFF')
        stripe_subscription = StripeSubscription.new(subscription)

        stripe_subscription.create

        new_subscription = customer.subscriptions.first
        expect(new_subscription[:plan]).to eq subscription.plan.stripe_plan_id
        expect(new_subscription[:coupon]).to eq '25OFF'
      end
    end

    it "creates a customer if one isn't assigned" do
      stub_stripe_customer(returning_customer_id: 'stripe')

      subscription = build(:subscription, subscriber: create(:user))
      stripe_subscription = StripeSubscription.new(subscription)

      stripe_subscription.create

      expect(subscription.stripe_customer_id).to eq 'stripe'
      expect(Stripe::Customer).to have_received(:create).
        with(hash_including(email: subscription.subscriber.email))
    end

    it "doesn't create a customer if one is already assigned" do
      subscription = build(:subscription)
      subscription.subscriber.stripe_customer_id = 'original'
      stub_stripe_customer
      stripe_subscription = StripeSubscription.new(subscription)

      stripe_subscription.create

      expect(subscription.subscriber.stripe_customer_id).to eq 'original'
      expect(Stripe::Customer).not_to have_received(:create)
    end

    it 'it adds an error message with a bad card' do
      allow(Stripe::Customer).to receive(:create).
        and_raise(Stripe::StripeError, 'Your card was declined')
      subscription = build(:subscription, subscriber: create(:user))
      stripe_subscription = StripeSubscription.new(subscription)

      result = stripe_subscription.create

      expect(result).to be false
      expect(subscription.errors[:base]).to include(
        t('flash.payment.problem_with_card', message: 'Your card was declined')
      )
    end
  end

  def stub_existing_customer
    subscriptions = FakeSubscriptionList.new([FakeSubscription.new])
    customer = double('customer', subscriptions: subscriptions)
    allow(customer).to receive(:card=)
    allow(customer).to receive(:save)
    allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
    customer
  end

  def stub_stripe_customer(returning_customer_id: 'unspecified')
    allow(Stripe::Customer).to receive(:create).
      and_return(double('StripeCustomer', id: returning_customer_id))
  end
end
