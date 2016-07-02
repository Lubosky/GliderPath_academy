class CreateChargeWorker
  include Sidekiq::Worker

  def perform(user_id, transaction_id, product)
    transaction = Braintree::Transaction.find(transaction_id)
    user = User.find_by_id(user_id)
    user.charges.create(charge_params(product, transaction))
    if user.has_suspended_subscription?
      user.subscription.activate
    end
  end

  def charge_params(product, transaction)
    {
      product: product,
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
