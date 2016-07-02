require 'spec_helper'

describe UpdatePaymentMethodWorker, sidekiq: :inline do

  before { allow(UpdatePaymentMethodWorker).to receive(:perform_in) }

  let(:user) { create :user, braintree_customer_id: 1 }

  before do
    @customer = init_braintree_customer
  end

  context '#update_payment_method', sidekiq: :inline do
    it 'updates user default payment method' do
      expect(@customer.payment_methods.find{ |pm| pm.default? }.last_4).to eq '4242'

      UpdatePaymentMethodWorker.perform_async(user.id, braintree_nonce(cc_number))
      expect(Braintree::PaymentMethod.find('token')).to_not be_nil

      braintree_customer = Braintree::Customer.find(user.braintree_customer_id)
      expect(braintree_customer.payment_methods.find{ |pm| pm.default? }.last_4).to eq '4444'

      user.reload
      expect(user.card_last4).to eq '4444'
    end
  end
end
