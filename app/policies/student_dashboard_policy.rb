class StudentDashboardPolicy < ApplicationPolicy
  def show?
    return true if user.present?
  end
end
