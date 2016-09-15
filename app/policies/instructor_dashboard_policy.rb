class InstructorDashboardPolicy < ApplicationPolicy
  def show?
    return true if user.present? && user.is_instructor?
  end
end
