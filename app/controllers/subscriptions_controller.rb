class SubscriptionsController < ApplicationController
  protect_from_forgery except: :webhook
  before_action :authenticate_user!, except: [:new, :webhook]
  before_action :redirect_to_signup, only: [:new]
  before_action :set_plan, only: [:create, :webhook]
  before_action :set_braintree_customer, only: [:create]

  def new
    authorize :subscription
    gon.braintree_client_token = generate_braintree_client_token
  end

  def create
    authorize :subscription
    result = Braintree::Subscription.create(
      payment_method_token: @customer.payment_methods.find{ |pm| pm.default? }.token,
      plan_id: @plan.braintree_plan_id
    )

    braintree_subscription = result.subscription

    if result.success?
      current_user.confirm unless current_user.confirmed?
      @subscription = Subscription.where(subscriber_id: current_user.id).first_or_initialize
      @subscription.update(subscription_params(braintree_subscription, @plan)) && @subscription.activate
      flash[:success] = t('flash.subscriptions.create.success', plan: @plan.name)
      redirect_to root_path
    else
      current_user.send_confirmation_instructions unless current_user.confirmed?
      flash[:alert] = t('flash.subscriptions.create.error')
      gon.braintree_client_token = generate_braintree_client_token
      render :new
    end

  end

  def destroy
    authorize :subscription
    subscription = current_user.subscription.braintree_subscription_id
    result = Braintree::Subscription.cancel(subscription)
    if result.success?
      current_user.subscription.cancel
      flash[:info] = t('flash.subscriptions.cancel.success')
    else
      flash[:error] = t('flash.subscriptions.cancel.error')
    end
    redirect_to root_path
  end

  def webhook
    skip_authorization

    if params[:bt_challenge]
      return render plain: Braintree::WebhookNotification.verify(params[:bt_challenge])
    end

    webhook_notification = Braintree::WebhookNotification.parse(params[:bt_signature], params[:bt_payload])

    kind = webhook_notification.kind

    # subscription_canceled
    # subscription_charged_successfully
    # subscription_charged_unsuccessfully

    case kind
      when 'subscription_canceled'
        puts webhook_notification.kind

      when 'subscription_charged_successfully'
        puts webhook_notification.kind

        transaction = webhook_notification.subscription.transactions.last
        user = User.find_by_braintree_customer_id(transaction.customer_details.id)
        plan = user.plan
        user.charges.create(charge_params(plan, transaction))

      when 'subscription_charged_unsuccessfully'
        puts webhook_notification.kind
        puts webhook_notification.subscription.failure_count

        transaction = webhook_notification.subscription.transactions.last
        errors = transaction.errors

      else
        raise "Braintree notification: #{kind} - #{webhook_notification.subscription.id} - #{webhook_notification.timestamp}"
    end

    head :ok
  end

  private

    def redirect_to_signup
      if !user_signed_in?
        session['user_return_to'] = new_subscription_path(plan: params[:plan])
        redirect_to new_user_registration_path
      end
    end

    def set_plan
      @plan = Plan.find_by(id: params[:plan])
    end

    def generate_braintree_client_token
      current_user.init_braintree_client_token
    end

    def subscription_params(braintree_subscription, plan)
      {
        braintree_subscription_id: braintree_subscription.id,
        subscriber_id: current_user.id,
        plan_id: plan.id
      }
    end

    def charge_params(plan, transaction)
      {
        product: plan.name,
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
