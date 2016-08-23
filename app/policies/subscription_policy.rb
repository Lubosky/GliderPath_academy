class SubscriptionPolicy < ApplicationPolicy
  def new?
    return true if user.present? && !user.has_active_subscription?
  end

  def create?
    new?
  end

  def destroy?
    return true if user.present? && user.has_active_subscription?
  end
end
