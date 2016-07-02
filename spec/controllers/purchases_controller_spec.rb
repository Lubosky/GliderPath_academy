require 'spec_helper'

RSpec.describe PurchasesController, type: :controller do
  let(:user) { create(:user, braintree_customer_id: 1) }
  let(:course) { create(:course) }

  describe 'GET #new' do

    context 'when user is logged in' do
      before do
        login user
        init_braintree_customer
      end

      it {
        get :new, params: { course_id: course.id }
        expect(response).to render_template :new
      }
    end

    context 'when user is not logged in' do
      it {
        get :new, params: { course_id: course.id }
        expect(response).to redirect_to new_user_registration_path
      }
    end

    context 'when user already purchased' do
      before do
        login user
        init_braintree_customer
      end

      it {
        post :create, params: { course_id: course.id, purchaser_id: user.id }
        get :new, params: { course_id: course.id }
        expect(response).to redirect_to root_path
        expect(flash[:warning]).to match t('flash.purchases.alert', purchase: course.name)
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
        post :create, params: { course_id: course.id, purchaser_id: user.id }
      }.to change(Purchase, :count).by(1)
      expect(response).to redirect_to course_path(course)
    }
  end

end
