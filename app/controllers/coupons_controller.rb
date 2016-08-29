class CouponsController < ApplicationController
  def show
    authorize :coupon

    if coupon.valid?
      session[:coupon] = coupon.code
      flash[:notice] = t('flash.coupons.success', code: coupon.code)
    else
      flash[:error] = t('flash.coupons.invalid')
    end

    redirect_to root_path
  end

  private

  def coupon
    @coupon ||= Coupon.new(params[:id])
  end
end
