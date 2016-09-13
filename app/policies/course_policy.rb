class CoursePolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    course.published? || user.is_admin? || user_is_instructor?
  end

  def create?
    user.present? && (user.is_admin? || user.is_instructor?)
  end

  def update?
    return true if user.present? && (user.is_admin? || user_is_instructor?)
  end

  def destroy?
    user.present? && user.is_admin?
  end

  def progress?
    user.present? && user.enrolled?(course)
  end

  def sort?
    update?
  end

  private

  def course
    record
  end

  def user_is_instructor?
    user.is_instructor? && (user == course.instructor)
  end
end
