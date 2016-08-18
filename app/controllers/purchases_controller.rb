class PurchasesController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]
  before_action :check_if_purchased, only: [:new]

  def new
    authorize :purchase
    gon.stripe_public_key = STRIPE_PUBLIC_KEY
    @purchase = build_purchase({})
  end

  def create
    authorize :purchase
    @purchase = build_purchase(purchase_params)
    if @purchase.fulfill
      flash[:success] = t('flash.purchases.create.success', user: current_user.first_name, purchase: purchasable.name)
      analytics.track_product_purchased(analytics_metadata_for_purchasable)
      redirect_to purchasable
    else
      flash[:alert] = t('flash.purchases.create.error')
      render :new
    end
  end

  private

  def build_purchase(arguments)
    purchasable.purchases.build(
      arguments.merge(default_params)
    )
  end

  def default_params
    {
      purchaser: current_user,
      product_name: purchasable.name,
      product_price: purchasable.price
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
