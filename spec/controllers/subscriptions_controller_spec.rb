require 'spec_helper'

RSpec.describe SubscriptionsController, type: :controller do
  include CurrentUserHelper

  let(:user) { create(:user, stripe_customer_id: 1) }
  let(:plan) { create(:plan) }

  describe 'GET #new' do
    context 'when user is logged in' do
      it {
        confirm_and_login_user_with(user)

        get :new, params: { plan: plan }
        expect(response).to have_http_status(:success)
        expect(response).to render_template :new
      }
    end

    context 'when user is not logged in' do
      it {
        get :new, params: { plan: plan }
        expect(response).to redirect_to new_user_registration_path
      }
    end

    context 'when no plan is found' do
      it {
        confirm_and_login_user_with(user)

        get :new
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(302)
      }
    end

  end

  describe 'GET #create' do
    before do
      confirm_and_login_user_with(user)
    end

    it {
      expect {
        post :create, params: { subscription: customer_params, plan: plan }
      }.to change(Subscription, :count).by(1)
    }
  end

  def confirm_and_login_user_with(user)
    user.confirm
    login user
  end

  def customer_params(token = 'stripe token')
    {
      name: 'User',
      email: 'test@example.com',
      stripe_token: token
    }
  end
end
