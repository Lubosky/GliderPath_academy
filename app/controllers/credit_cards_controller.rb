class CreditCardsController < ApplicationController
  before_action :authenticate_user!

  def update
    authorize :credit_card
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    customer.card = params['stripe_token']
    begin
      customer.save
      flash[:success] = t('flash.credit_cards.success')
    rescue Stripe::CardError => error
      flash[:alert] = t('flash.credit_cards.alert', message: error.message)
    end
    redirect_to account_charges_path
  end
end
