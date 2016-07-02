class SubscriptionPolicy < ApplicationPolicy

  def new?
    return true if user.present? && !user_has_subscription?
  end

  def create?
    new?
  end

  def destroy?
    return true if user.present? && user_has_subscription?
  end

  private

    def user_has_subscription?
      user.has_active_subscription? || user.has_suspended_subscription?
    end

end
