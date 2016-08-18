class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]
  before_action :redirect_when_plan_not_found, only: [:new, :create]

  def new
    authorize :subscription
    gon.stripe_public_key = STRIPE_PUBLIC_KEY
    @subscription = build_subscription({})
  end

  def create
    authorize :subscription
    @subscription = build_subscription(subscription_params)
    if @subscription.fulfill
      flash[:success] = t('flash.subscriptions.create.success', plan: plan.name)
      redirect_to root_path
    else
      flash[:alert] = t('flash.subscriptions.create.error')
      render :new
    end
  end

  def destroy
    authorize :subscription
    current_user.cancel_subscription
    flash[:info] = t('flash.subscriptions.cancel')
    redirect_to root_path
  end

  private

  def build_subscription(arguments)
    subscription = Subscription.where(subscriber: current_user).first_or_initialize
    subscription.attributes = arguments.merge(default_params)
    subscription
  end

  def default_params
    {
      plan: plan
    }
  end

  def subscription_params
    params.require(:subscription).permit(
      :stripe_token
    )
  end

  def plan
    @plan ||= Plan.find_by(id: params[:plan])
  end

  def redirect_to_signup
    unless user_signed_in?
      session['user_return_to'] = new_subscription_path(plan: params[:plan])
      redirect_to new_user_registration_path
    end
  end

  def redirect_when_plan_not_found
    unless plan.present?
      flash[:info] = t('flash.plans.not_found')
      redirect_to root_path
    end
  end
end
