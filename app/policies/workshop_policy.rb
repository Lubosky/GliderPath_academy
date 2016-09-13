class WorkshopPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    workshop.published? || user.is_admin? || user_is_instructor?
  end

  def create?
    user.present? && (user.is_admin? || user.is_instructor?)
  end

  def update?
    user.present? && (user.is_admin? || user_is_instructor?)
  end

  def destroy?
    user.present? && user.is_admin?
  end

  private

  def workshop
    record
  end

  def user_is_instructor?
    user.is_instructor? && (user == workshop.instructor)
  end
end
