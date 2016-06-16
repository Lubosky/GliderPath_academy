class EnrollmentPolicy < ApplicationPolicy

  def create?
    return true if user.present? && user.subscribed?
  end

end
