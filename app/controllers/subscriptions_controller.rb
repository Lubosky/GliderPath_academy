class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :redirect_to_signup, only: [:new]
  before_action :redirect_when_plan_not_found, only: [:new, :create]

  def new
    authorize :subscription
    build_subscription({}) do |subscription|
      @subscription = subscription
      render :new
    end
  end

  def create
    authorize :subscription
    build_subscription(subscription_params) do |subscription|
      success = subscription.fulfill
      if success
        session.delete(:coupon)
        track_subscription
        redirect_after_subscription
      else
        @subscription = subscription
        flash[:alert] = t('flash.subscriptions.create.error')
        render :new
      end
    end
  end

  def destroy
    authorize :subscription
    @cancellation = Cancellation.new(
      subscription: current_user.subscription
    ).schedule

    flash[:info] = t('flash.subscriptions.cancel')
    redirect_to root_path
  end

  private

  def build_subscription(arguments)
    subscription = Subscription.where(subscriber: current_user).first_or_initialize
    subscription.attributes = arguments
        .merge(default_params)
        .merge(coupon_params)

    if subscription.has_invalid_coupon?
      redirect_from_invalid_coupon
    else
      yield subscription
    end
  end

  def default_params
    {
      plan: plan
    }
  end

  def coupon_params
    {
      stripe_coupon_id: session[:coupon]
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

  def redirect_from_invalid_coupon
    flash[:warning] = t('flash.subscriptions.invalid_coupon', code: session[:coupon])
    session.delete(:coupon)
    redirect_to new_subscription_path(plan: params[:plan])
  end

  def redirect_after_subscription
    flash[:success] = t('flash.subscriptions.create.success', plan: plan.name)
    redirect_to root_path
  end

  def track_subscription
    analytics.track_subscribed(
      plan: plan.name,
      revenue: '99.0'.freeze
    )
  end
end
