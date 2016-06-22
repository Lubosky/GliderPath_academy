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
    result = Braintree::Transaction.sale(
      payment_method_token: @customer.payment_methods.find{ |pm| pm.default? }.token,
      amount: 99,
      options: {
        store_in_vault_on_success: true,
        submit_for_settlement: true
      }
    )

    @purchase = @purchasable.purchases.build(params[:purchase])

    options = {
      braintree_purchase_id: result.transaction.id,
      purchaser_id: current_user.id
    }

    charge_params = {
      product: @purchasable.name,
      amount: result.transaction.amount,
      braintree_transaction_id: result.transaction.id,
      braintree_payment_method: result.transaction.payment_instrument_type,
      paypal_email: result.transaction.paypal_details.payer_email,
      card_type: result.transaction.credit_card_details.card_type,
      card_exp_month: result.transaction.credit_card_details.expiration_month,
      card_exp_year: result.transaction.credit_card_details.expiration_year,
      card_last4: result.transaction.credit_card_details.last_4
    }

    if ( result.success? && @purchase.update_attributes(options) )
      current_user.confirm unless current_user.confirmed?

      current_user.charges.create(charge_params)

      flash[:success] = t('flash.purchases.create.success', user: current_user.first_name, purchase: @purchasable.name)
      redirect_to @purchasable

    else
      current_user.send_confirmation_instructions unless current_user.confirmed?

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
      @purchasable = klass.find_by(id: params["#{ klass.name.underscore }_id"])
    end

    def check_if_purchased
      if current_user.purchased?(@purchasable)
        flash[:warning] = t('flash.purchases.alert', purchase: @purchasable.name)
        redirect_back(fallback_location: root_path)
      end
    end

    def generate_braintree_client_token
      if current_user.braintree_customer?
        Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end

    def find_braintree_customer
      @customer = Braintree::Customer.find(current_user.braintree_customer_id)
    end

    def set_braintree_customer
      payment_method_nonce = params[:payment_method_nonce]
      current_user.init_braintree_customer(payment_method_nonce)
      if false
        flash[:alert] = t('flash.payment.alert')
        redirect_back(fallback_location: root_path)
      else
        find_braintree_customer
      end
    end

end
