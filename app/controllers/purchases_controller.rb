class PurchasesController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]
  before_action :set_purchase, only: [:new, :create]
  before_action :check_if_purchased, only: [:new]
  before_action :set_braintree_customer, only: [:create]

  def new
    authorize :purchase
    gon.braintree_client_token = generate_braintree_client_token
    @purchase = @purchasable.purchases.build
  end

  def create
    authorize :purchase
    current_user.create_purchase(@purchasable)
    if true
      flash[:success] = t('flash.purchases.create.success', user: current_user.first_name, purchase: @purchasable.name)
      analytics.track_product_purchased(analytics_metadata_for_purchasable)
      redirect_to @purchasable
    else
      flash[:alert] = t('flash.purchases.create.error')
      gon.braintree_client_token = generate_braintree_client_token
      render :new
    end

  end

  private

    def redirect_to_signup
      if !user_signed_in?
        session['user_return_to'] = request.url
        redirect_to new_user_registration_path
      end
    end

    def set_purchase
      klass = [Course].detect { |p| params["#{ p.name.underscore }_id"] }
      @purchasable = klass.find_by_slug(params["#{ klass.name.underscore }_id"])
    end

    def check_if_purchased
      if current_user.purchased?(@purchasable)
        flash[:warning] = t('flash.purchases.alert', purchase: @purchasable.name)
        redirect_back(fallback_location: root_path)
      end
    end

    def generate_braintree_client_token
      current_user.init_braintree_client_token
    end

    def analytics_metadata_for_purchasable
      {
        type: @purchasable.class.to_s,
        product: @purchasable.name,
        price: @purchasable.price
      }
    end

end
