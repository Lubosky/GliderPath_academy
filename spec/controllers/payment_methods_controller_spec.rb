require 'spec_helper'

RSpec.describe PaymentMethodsController, type: :controller do
  let(:user) { create(:user, braintree_customer_id: 1) }

  describe 'POST #create' do
    before do
      login user
     end

    it {
      post :create, params: { payment_method_nonce: braintree_nonce(cc_number) }
      expect(response).to redirect_to account_charges_path
    }

  end

end
