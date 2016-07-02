class SubscriptionsController < ApplicationController
  protect_from_forgery except: :webhook
  before_action :authenticate_user!, except: [:new, :webhook]
  before_action :redirect_to_signup, only: [:new]
  before_action :redirect_when_plan_not_found, only: [:new, :create]
  before_action :set_braintree_customer, only: [:create]

  def new
    authorize :subscription
    gon.braintree_client_token = generate_braintree_client_token
  end

  def create
    authorize :subscription
    current_user.create_subscription(plan)
    if true
      flash[:success] = t('flash.subscriptions.create.success', plan: plan.name)
      redirect_to root_path
    else
      flash[:alert] = t('flash.subscriptions.create.error')
      gon.braintree_client_token = generate_braintree_client_token
      render :new
    end
  end

  def destroy
    authorize :subscription
    current_user.cancel_subscription
    flash[:info] = t('flash.subscriptions.cancel')
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
        subscriber = User.find_by_braintree_customer_id(transaction.customer_details.id)

        CreateChargeWorker.perform_async(subscriber.id, transaction.id, subscriber.plan.name)

      when 'subscription_charged_unsuccessfully'
        puts webhook_notification.kind
        failure_count = webhook_notification.subscription.failure_count

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

    def plan
      Plan.find_by(id: params[:plan])
    end

    def redirect_when_plan_not_found
      if !plan.present?
        redirect_to root_path
        flash[:info] = t('flash.plans.not_found')
      end
    end

    def generate_braintree_client_token
      current_user.init_braintree_client_token
    end

end
