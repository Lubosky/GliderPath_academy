require 'spec_helper'

RSpec.describe CouponsController, type: :controller do
  describe '#show' do
    context 'with valid coupon' do
      it 'should set a valid coupon in the session' do
        stripe_coupon = double(Stripe::Coupon, valid: true)
        allow(Stripe::Coupon).to receive(:retrieve).and_return(stripe_coupon)

        get :show, params: { id: '50OFF' }

        expect(session[:coupon]).to eq('50OFF')
        expect(flash[:notice]).to(
          eq t('flash.coupons.success', code: '50OFF')
        )
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid coupon' do
      it 'should not set a coupon in session' do
        stripe_coupon = double(Stripe::Coupon, valid: false)
        allow(Stripe::Coupon).to receive(:retrieve).and_return(stripe_coupon)

        get :show, params: { id: '25OFF' }

        expect(session[:coupon]).to be_nil
        expect(flash[:error]).to eq t('flash.coupons.invalid')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
