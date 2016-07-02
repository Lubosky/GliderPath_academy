class PurchasePolicy < ApplicationPolicy

  def new?
    return true if user.present? && !(user.has_active_subscription? || user.has_suspended_subscription?)
  end

  def create?
    new?
  end

end
