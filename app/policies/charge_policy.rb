class ChargePolicy < ApplicationPolicy

  def index?
    return true if user.present?
  end

  def show?
    return true if user.present? && user == charge.user
  end

  private

  def charge
    record
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
