require 'spec_helper'

RSpec.describe PaymentMethodsController, type: :controller do
  let(:user) { create(:user, braintree_customer_id: 1) }

  describe 'POST #create' do
    before do
      login user
      @customer = braintree_customer
    end

    it {
      expect(@customer.payment_methods.find{ |pm| pm.default? }.last_4).to eq('4242')

      post :create, params: { payment_method_nonce: braintree_nonce(cc_number) }

      result = Braintree::PaymentMethod.create(payment_method_nonce: braintree_nonce(cc_number))
      expect(result).to be_success
      expect(response).to redirect_to account_charges_path
      expect(Braintree::PaymentMethod.find('token')).to_not be_nil

      @customer = Braintree::Customer.find(user.braintree_customer_id)
      expect(@customer.payment_methods.find{ |pm| pm.default? }.last_4).to eq('4444')
    }

  end

end
