class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]
  before_action :set_plan, only: [:create]
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

    if result.success?
      current_user.confirm unless current_user.confirmed?

      subscription_attributes = {
        braintree_subscription_id: result.subscription.id,
        subscriber_id: current_user.id,
        plan_id: @plan.id
      }

      @subscription = Subscription.where(subscriber_id: current_user.id).first_or_initialize
      @subscription.update(subscription_attributes) && @subscription.activate
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
      if current_user.braintree_customer?
        Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end

    def set_braintree_customer
      if current_user.braintree_customer?
        @customer = Braintree::Customer.find(current_user.braintree_customer_id)
      else
        result = Braintree::Customer.create(
          first_name: current_user.first_name,
          last_name: current_user.last_name,
          email: current_user.email,
          payment_method_nonce: params[:payment_method_nonce],
          credit_card: {
            options: {
              verify_card: true
            }
          }
        )
        @customer = result.customer

        current_user.update(braintree_customer_id: @customer.id)
      end
    end

end
