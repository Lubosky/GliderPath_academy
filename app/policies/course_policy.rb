class CoursePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present? && ( user.is_admin? || user.is_instructor? )
  end

  def update?
    return true if user.present? && ( user.is_admin? || ( user.is_instructor? && ( user == course.user ) ) )
  end

  def destroy?
    user.present? && user.is_admin?
  end

  private

    def course
      record
    end

end