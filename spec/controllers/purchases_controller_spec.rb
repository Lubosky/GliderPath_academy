require 'spec_helper'

include CurrentUserHelper

RSpec.describe PurchasesController, type: :controller do
  describe 'GET #new' do

    context 'when user is logged in' do
      it 'renders a new template' do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        course_id = stub_valid_course_id

        get :new, params: { course_id: course_id }

        expect(response).to render_template :new
      end
    end

    context 'when user is not logged in' do
      it 'redirects to new registration path' do
        course_id = stub_valid_course_id

        get :new, params: { course_id: course_id }

        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'when user already purchased' do
      it 'displays a warning and redirects to root path' do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        course = stub_course
        allow(user).to receive(:purchased?).with(course).and_return(true)

        get :new, params: { course_id: course.id }

        expect(response).to redirect_to root_path
        expect(flash[:warning]).to match t('flash.purchases.alert', purchase: course.name)
      end
    end

    context 'with a valid stripe_coupon in the session' do
      it 'should set a stripe_coupon_id on the checkout' do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        coupon = stub_coupon(valid: true)
        session[:coupon] = coupon.code
        course_id = stub_valid_course_id

        get :new, params: { course_id: course_id }

        expect(assigns(:purchase).stripe_coupon_id).to eq coupon.code
      end
    end

    context 'with an invalid stripe_coupon in the session' do
      it 'renders an error and removes the coupon' do
        user = build_stubbed(:user)
        stub_current_user_with(user)
        coupon_code = stub_coupon(valid: false).code
        session[:coupon] = coupon_code
        course_id = stub_valid_course_id

        get :new, params: { course_id: course_id.to_i }

        expect(session[:coupon]).to be_nil
        expect(controller).to render_template(:new)
        expect(flash[:warning])
          .to match t('flash.purchases.invalid_coupon', code: coupon_code)
      end
    end
  end

  describe 'GET #create' do
    it 'sets flash message and redirects to purchased item' do
      user = create(:user, :with_stripe)
      confirm_and_login_user_with(user)
      course = create(:course)

      post :create, params: { purchase: customer_params, course_id: course, purchaser_id: user }

      expect(response).to redirect_to course
      expect(flash[:success])
        .to match t('flash.purchases.create.success', user: user.first_name, purchase: course.name)
    end

    it 'removes any coupon from the session' do
      create(:coupon, code: '10OFF')
      user = create(:user, :with_stripe)
      confirm_and_login_user_with(user)
      course = create(:course)
      stripe_token = 'token'
      session[:coupon] = '10OFF'

      post(
        :create,
        params: {
          purchase: customer_params(stripe_token).merge(stripe_coupon_id: '10OFF'),
          course_id: course,
          purchaser_id: user
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
      stripe_token: token
    }
  end

  def stub_valid_course_id
    stub_course.id
  end

  def stub_course(*attributes)
    build_stubbed(:course, *attributes).tap do |course|
      allow(Course).to receive(:find_by).with(slug: course.id.to_s).and_return(course)
    end
  end

  def stub_coupon(valid:)
    create(:coupon).tap do |coupon|
      allow(Coupon).to receive(:new).with(coupon.code).and_return(coupon)
      allow(coupon).to receive(:valid?).and_return(valid)
    end
  end
end
