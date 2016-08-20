class ReactivationPolicy < ApplicationPolicy
  def create?
    return true if user.present? && user.subscription
  end
end
