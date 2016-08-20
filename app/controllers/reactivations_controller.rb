class ReactivationsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize :reactivation
    reactivation = Reactivation.new(subscription: current_user.subscription)
    if reactivation.fulfill
      analytics.track_subscription_reactivated
      flash[:notice] = t('flash.subscriptions.reactivate.success')
    else
      flash[:error] = t('flash.subscriptions.reactivate.error')
    end
    redirect_to root_path
  end
end
