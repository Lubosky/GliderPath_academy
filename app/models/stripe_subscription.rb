class StripeSubscription
  attr_reader :id

  def initialize(subscription)
    @subscription = subscription
  end

  def create
    rescue_stripe_exception do
      ensure_customer_exists
      update_subscription
    end
  end

  def reactivate
    rescue_stripe_exception do
      reactivate_subscription
    end
  end

  private

  def rescue_stripe_exception
    yield
    true
  rescue Stripe::StripeError => exception
    @subscription.errors[:base] <<
      I18n.t('flash.payment.problem_with_card', message: exception.message)
    false
  end

  def ensure_customer_exists
    StripeCustomer.new(
      @subscription.subscriber,
      @subscription.stripe_token
    ).ensure_customer_exists
  end

  def update_subscription
    if stripe_customer.subscriptions.total_count.zero?
      subscription =
        stripe_customer.subscriptions.create(stripe_subscription_attributes)
    else
      subscription = stripe_customer.subscriptions.first
      stripe_subscription_attributes.each { |key, value| subscription[key] = value }
      subscription.save
    end

    @id = subscription.id
  end

  def reactivate_subscription
    subscription = stripe_customer.subscriptions.first
    subscription.plan = subscription.plan.id
    subscription.save
  end

  def stripe_subscription_attributes
    {
      plan: @subscription.stripe_plan_id
    }
  end

  def stripe_customer
    @stripe_customer ||=
      Stripe::Customer.retrieve(@subscription.stripe_customer_id)
  end
end
