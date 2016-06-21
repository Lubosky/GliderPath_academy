class PurchasePolicy < ApplicationPolicy

  def new?
    return true if user.present? && !user.subscribed?
  end

  def create?
    new?
  end

end
