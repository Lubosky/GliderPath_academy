require 'spec_helper'

describe StripeCustomer do
  context '#ensure_customer_exists' do
    context 'when there is an existing Stripe Customer record' do
      it "updates the user's credit card" do
        stripe_customer_id = 'cus12345'
        token = 'stripe_token'

        user = User.new(stripe_customer_id: stripe_customer_id)
        stripe_customer = stub_existing_customer
        allow(stripe_customer).to receive(:card=)
        allow(stripe_customer).to receive(:save)

        customer = StripeCustomer.new(user, token)
        customer.ensure_customer_exists

        expect(stripe_customer).to have_received(:card=).with(token)
        expect(stripe_customer).to have_received(:save)
      end
    end

    it "creates a customer if one isn't assigned" do
      token = 'stripe_token'

      user = User.new
      stripe_customer = stub_stripe_customer(returning_customer_id: 'stripe')

      customer = StripeCustomer.new(user, token)
      customer.ensure_customer_exists

      expect(user.stripe_customer_id).to eq 'stripe'
      expect(Stripe::Customer).to have_received(:create).
        with(
          hash_including(
            description: user.name,
            email: user.email
          )
        )
    end

    it "doesn't create a customer if one is already assigned" do
      stripe_customer_id = 'original'
      token = 'stripe_token'

      user = User.new(stripe_customer_id: stripe_customer_id)

      stub_stripe_customer

      customer = StripeCustomer.new(user, token)
      customer.ensure_customer_exists

      expect(user.stripe_customer_id).to eq 'original'
      expect(Stripe::Customer).not_to have_received(:create)
    end
  end

  describe '#url' do
    it 'returns a url to the customer in the stripe management console' do
      stripe_customer_id = 'cus12345'
      url = "https://manage.stripe.com/customers/#{stripe_customer_id}"
      user = User.new(stripe_customer_id: stripe_customer_id)
      token = 'stripe_token'

      expect(StripeCustomer.new(user, token).url).to eq(url)
    end

    it 'returns nil if the user has no stripe_customer_id' do
      user = User.new(stripe_customer_id: nil)
      token = 'stripe_token'

      expect(StripeCustomer.new(user, token).url).to be_nil
    end
  end

  def stub_existing_customer
    subscriptions = FakeSubscriptionList.new([FakeSubscription.new])
    customer = double('customer', subscriptions: subscriptions)
    allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
    customer
  end

  def stub_stripe_customer(returning_customer_id: 'unspecified')
    allow(Stripe::Customer).to receive(:create).
      and_return(double('StripeCustomer', id: returning_customer_id))
  end
end
