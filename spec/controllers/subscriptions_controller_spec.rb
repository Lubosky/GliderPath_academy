require 'spec_helper'

include CurrentUserHelper

RSpec.describe SubscriptionsController, type: :controller do
  describe 'GET #new' do
    context 'when user is logged in' do
      it 'renders a new template' do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        plan_id = stub_valid_plan_id

        get :new, params: { plan: plan_id }

        expect(response).to have_http_status(:success)
        expect(response).to render_template :new
      end
    end

    context 'when user is not logged in' do
      it 'redirects to new registration path' do
        plan_id = stub_valid_plan_id

        get :new, params: { plan: plan_id }

        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'when no plan is found' do
      it 'redirects to root path' do
        user = build_stubbed(:user)
        stub_current_user_with(user)

        get :new

        expect(response).to redirect_to root_path
        expect(response).to have_http_status(302)
      end
    end

  end

  describe 'GET #create' do
    it 'increases subscription_count by 1' do
      user = create(:user, :with_stripe)
      confirm_and_login_user_with(user)
      plan = create(:plan)

      expect {
        post :create, params: { subscription: customer_params, plan: plan }
      }.to change(Subscription, :count).by(1)
    end

    it 'sets flash message' do
      user = create(:user, :with_stripe)
      confirm_and_login_user_with(user)
      plan = create(:plan)

      post :create, params: { subscription: customer_params, plan: plan }

      expect(flash[:success])
        .to match t('flash.subscriptions.create.success', plan: plan.name)
    end

    it 'removes any coupon from the session' do
      create(:coupon, code: '20OFF')
      user = create(:user, :with_stripe)
      confirm_and_login_user_with(user)
      plan = create(:plan)
      session[:coupon] = '20OFF'

      post(
        :create,
        params: {
          subscription: customer_params.merge(stripe_coupon_id: '20OFF'),
          plan: plan
        }
      )

      expect(session[:coupon]).to be_nil
    end
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

  def stub_valid_plan_id
    stub_plan.id
  end

  def stub_plan(*attributes)
    build_stubbed(:plan, *attributes).tap do |plan|
      allow(Plan).to receive(:find_by).with(id: plan.id.to_s).and_return(plan)
    end
  end

  def stub_coupon(valid:)
    create(:coupon).tap do |coupon|
      allow(Coupon).to receive(:new).with(coupon.code).and_return(coupon)
      allow(coupon).to receive(:valid?).and_return(valid)
    end
  end
end
