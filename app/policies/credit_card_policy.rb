class CreditCardPolicy < ApplicationPolicy

  def update?
    return true if user.present? && user.has_credit_card?
  end

end
