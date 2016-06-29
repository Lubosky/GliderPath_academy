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
      amount: 99.0,
      options: {
        store_in_vault_on_success: true,
        submit_for_settlement: true
      }
    )
    transaction = result.transaction
    @purchase = @purchasable.purchases.build(params[:purchase])

    if ( result.success? && @purchase.update_attributes(purchase_params(transaction)) )
      current_user.confirm unless current_user.confirmed?
      current_user.charges.create(charge_params(@purchasable, transaction))
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
      current_user.init_braintree_client_token
    end

    def purchase_params(transaction)
      {
        braintree_purchase_id: transaction.id,
        purchaser_id: current_user.id
      }
    end

    def charge_params(product, transaction)
      {
        product: product.name,
        amount: transaction.amount,
        braintree_transaction_id: transaction.id,
        braintree_payment_method: transaction.payment_instrument_type,
        paypal_email: transaction.paypal_details.payer_email,
        card_type: transaction.credit_card_details.card_type,
        card_exp_month: transaction.credit_card_details.expiration_month,
        card_exp_year: transaction.credit_card_details.expiration_year,
        card_last4: transaction.credit_card_details.last_4
      }
    end
end
