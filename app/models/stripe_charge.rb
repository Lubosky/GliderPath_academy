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

  def charge_amount
    if @purchase.stripe_coupon_id.blank?
      @purchase.price
    else
      @purchase.coupon.apply(@purchase.price)
    end
  end

  def amount_in_cents
    (charge_amount * 100).to_i
  end

  def stripe_charge_attributes
    base_charge_attributes.merge(coupon_attributes)
  end

  def base_charge_attributes
    {
      amount: amount_in_cents,
      currency: 'gbp',
      customer: stripe_customer.id,
      description: @purchase.name
    }
  end

  def coupon_attributes
    if @purchase.stripe_coupon_id.present?
      {
        metadata: {
          coupon: @purchase.stripe_coupon_id
        }
      }
    else
      {}
    end
  end
end
