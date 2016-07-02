class UpdatePaymentMethodWorker
  include Sidekiq::Worker

  def perform(user_id, payment_method_nonce)
    user = User.find(user_id)
    result = user.create_braintree_payment_method(payment_method_nonce)
    if result.success?
      payment_method = result.payment_method
      user.braintree_payment_method_attributes(payment_method)
      user.save
    end
  end

end
