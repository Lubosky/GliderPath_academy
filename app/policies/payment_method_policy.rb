class PaymentMethodPolicy < ApplicationPolicy

  def create?
    return true if user.present?
  end

end
