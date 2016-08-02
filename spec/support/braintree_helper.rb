def init_braintree_customer
  Braintree::Customer.create(
    id: user.braintree_customer_id,
    first_name: user.first_name,
    last_name: user.last_name,
    email: user.email,
    credit_card: {
      number: '4242424242424242'
    }
  ).customer
end

def braintree_nonce(options = {})
  hash = {
    number: options[:number] || '4242424242424242',
    cvv: '123',
    token: 'token',
    expiration_date: '09/2027',
    options: {
      make_default: true
    }
  }
  FakeBraintree::PaymentMethod.tokenize_card(hash)
end

def init_braintree_subscription
  Braintree::Subscription.create(
    id: 1,
    payment_method_nonce: braintree_nonce,
    plan_id: plan.braintree_plan_id
  )
end

def cc_number
  {
    number: '5555555555554444'
  }
end
