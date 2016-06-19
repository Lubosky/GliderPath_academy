class SubscriptionPolicy < ApplicationPolicy

  def new?
    return true if user.present? && !user.subscribed?
  end

  def create?
    new?
  end

  def destroy?
    return true if user.present? && user.subscribed?
  end

end
