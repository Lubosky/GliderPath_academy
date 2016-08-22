class StripeCustomer
  def initialize(user, token)
    @user = user
    @token = token
  end

  def ensure_customer_exists
    if customer_exists?
      update_card
    else
      create_customer
    end
    stripe_customer
  end

  def url
    if customer_exists?
      "https://manage.stripe.com/customers/#{id}"
    else
      nil
    end
  end

  private

  attr_reader :user, :token

  def update_card
    stripe_customer.card = token
    stripe_customer.save
  end

  def create_customer
    new_stripe_customer = Stripe::Customer.create(
      card: token,
      description: user.name,
      email: user.email
    )
    user.update(stripe_customer_id: new_stripe_customer.id)
  end

  def customer_exists?
    id.present?
  end

  def id
    user.stripe_customer_id
  end

  def stripe_customer
    @stripe_customer ||=
      Stripe::Customer.retrieve(id)
  end
end
