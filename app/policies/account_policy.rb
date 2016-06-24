class AccountPolicy < ApplicationPolicy

  def show?
    return true if user.present?
  end

  def edit?
    show?
  end

  def update_account?
    show?
  end

end

