require 'spec_helper'

RSpec.describe PaymentMethodsController, type: :controller do
  let(:user) { build_stubbed(:user) }

  describe 'POST #create' do
    before do
      login user
    end
    it {
      post :create
      expect(response).to redirect_to account_charges_path
    }
  end
end
