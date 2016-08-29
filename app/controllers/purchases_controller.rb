class PurchasesController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]
  before_action :check_if_purchased, only: [:new]

  def new
    authorize :purchase
    build_purchase({}) do |purchase|
      gon.stripe_public_key = STRIPE_PUBLIC_KEY
      @purchase = purchase
    end
  end

  def create
    authorize :purchase
    build_purchase(purchase_params) do |purchase|
      success = purchase.fulfill
      if success
        session.delete(:coupon)
        analytics.track_product_purchased(analytics_metadata_for_purchasable)
        redirect_after_purchase
      else
        flash[:alert] = t('flash.purchases.create.error')
        render :new
      end
    end
  end

  private

  def build_purchase(arguments)
    purchase = purchasable.purchases.build(
      arguments
        .merge(default_params)
        .merge(coupon_params)
    )

    if purchase.has_invalid_coupon?
      redirect_from_invalid_coupon
    else
      yield purchase
    end
  end

  def default_params
    {
      purchaser: current_user,
      name: purchasable.name,
      price: purchasable.price
    }
  end

  def coupon_params
    {
      stripe_coupon_id: session[:coupon]
    }
  end

  def purchase_params
    params.require(:purchase).permit(
      :stripe_token
    )
  end

  def redirect_to_signup
    unless user_signed_in?
      session['user_return_to'] = request.url
      redirect_to new_user_registration_path
    end
  end

  def redirect_from_invalid_coupon
    flash[:warning] = t('flash.purchases.invalid_coupon', code: session[:coupon])
    session.delete(:coupon)
    render :new
  end

  def redirect_after_purchase
    flash[:success] = t('flash.purchases.create.success', user: current_user.first_name, purchase: purchasable.name)
    redirect_to purchasable
  end

  def purchasable
    klass = [Course, Workshop].detect { |p| params["#{p.name.underscore}_id"] }
    klass.find_by_slug(params["#{klass.name.underscore}_id"])
  end
  helper_method :purchasable

  def check_if_purchased
    if current_user.purchased?(purchasable)
      flash[:warning] = t('flash.purchases.alert', purchase: purchasable.name)
      redirect_back(fallback_location: root_path)
    end
  end

  def analytics_metadata_for_purchasable
    {
      type: purchasable.class.to_s,
      product: purchasable.name,
      price: purchasable.price
    }
  end
end
