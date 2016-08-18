class StripeCharge
  attr_reader :id

  def initialize(purchase)
    @purchase = purchase
  end

  def create
    rescue_stripe_exception do
      ensure_customer_exists
      create_charge
    end
  end

  private

  attr_reader :stripe_customer

  def rescue_stripe_exception
    yield
    true
  rescue Stripe::StripeError => exception
    @purchase.errors[:base] <<
      I18n.t('flash.payment.problem_with_card', message: exception.message)
    false
  end

  def ensure_customer_exists
    @stripe_customer = StripeCustomer.new(
      @purchase.purchaser,
      @purchase.stripe_token
    ).ensure_customer_exists
  end

  def create_charge
    charge = stripe_customer.charges.create(stripe_charge_attributes)

    @id = charge.id
  end

  def stripe_charge_attributes
    {
      amount: (@purchase.product_price * 100).to_i,
      currency: 'usd',
      customer: stripe_customer.id,
      description: @purchase.product_name
    }
  end
end
