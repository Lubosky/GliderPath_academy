class PaymentMethodsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize :payment_method
    current_user.ensure_customer_exists(params[:payment_method_nonce])
    if false
      flash[:alert] = t('flash.payment_methods.alert')
    else
      flash[:success] = t('flash.payment_methods.success')
    end
    redirect_to account_charges_path
  end

end
