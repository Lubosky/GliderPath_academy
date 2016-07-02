require 'spec_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let(:user) { create(:user, braintree_customer_id: 1) }
  let(:plan) { create(:plan) }

  describe 'GET #new' do
    context 'when user is logged in' do
      it {
        login user
        get :new, params: { plan: plan }
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

    context 'when no plan is found' do
      it {
        login user
        get :new
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(302)
      }
    end

  end

  describe 'GET #create' do
    before do
      login user
      init_braintree_customer
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
      @subscription = create(:subscription, subscriber: user, plan: plan, braintree_subscription_id: 1)
    end

    it 'redirects to root path if user = subscriber' do
      delete :destroy, params: { subscription: @subscription }
      expect(response).to redirect_to root_path
      expect(flash[:info]).to match t('flash.subscriptions.cancel')
    end
  end

end
