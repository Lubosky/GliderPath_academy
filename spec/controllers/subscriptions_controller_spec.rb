require 'spec_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let(:user) { create(:user, braintree_customer_id: 1) }
  let(:plan) { create(:plan) }

  describe 'GET #new' do
    context 'when user is logged in' do
      before do
        login user
        braintree_customer
      end

      it {
        expect(Braintree::ClientToken).to receive(:generate).and_return('token')
        get :new, params: { plan_id: plan.id }
        expect(response).to have_http_status(:success)
        expect(response).to render_template :new
      }
    end

    context 'when user is not logged in' do
      it {
        get :new, params: { plan_id: plan.id }
        expect(response).to redirect_to new_user_registration_path
      }
    end

  end

  describe 'GET #create' do
    before do
      login user
      braintree_customer
    end

    it {
      expect {
        post :create, params: { plan: plan, subscriber: user }
      }.to change(Subscription, :count).by(1)
    }
  end

  describe 'GET #destroy' do

    before do
      login user
      braintree_customer
      braintree_subscription
      @subscription = create(:subscription, subscriber: user, plan: plan, braintree_subscription_id: 1)
    end

    it 'changes subscription status from active to cancelled' do
      delete :destroy, params: { subscription: @subscription }
      expect(@subscription.status).to eq 'cancelled'

    end
  end

end
