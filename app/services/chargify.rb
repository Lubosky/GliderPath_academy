class Chargify
  def initialize(stripe_charge)
    @stripe_charge = stripe_charge
  end

  def process
    create_charge
  end

  private

  attr_reader :stripe_charge

  def amount
    cents_to_dollars(stripe_charge.amount)
  end

  def cents_to_dollars(amount)
    amount / 100.0
  end

  def create_charge
    user.charges.create(charge_attributes)
  end

  def charge_attributes
    {
      product: product,
      amount: amount,
      stripe_charge_id: stripe_charge_id,
      card_brand: stripe_charge.source.brand,
      card_exp_month: stripe_charge.source.exp_month,
      card_exp_year: stripe_charge.source.exp_year,
      card_last4: stripe_charge.source.last4
    }
  end

  def product
    if subscription_charge?
      stripe_plan
    else
      stripe_charge.description
    end
  end

  def stripe_charge_id
    stripe_charge.id
  end

  def stripe_invoice
    Stripe::Invoice.retrieve(stripe_charge.invoice)
  end

  def stripe_subscription
    stripe_invoice['lines']['data'].first
  end

  def stripe_plan
    stripe_subscription.plan.name
  end

  def subscription_charge?
    stripe_charge.invoice.present?
  end

  def user
    @user ||= User.find_by(stripe_customer_id: stripe_charge.customer)
  end
end
