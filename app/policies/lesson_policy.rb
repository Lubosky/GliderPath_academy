class LessonPolicy < ApplicationPolicy
  def show?
    user.present? && user_has_access?
  end

  def complete?
    show?
  end

  def preview?
    user.present? && user.is_admin? || user_is_instructor?
  end

  private

  def user_has_access?
    user.has_access_to?(record.course) && user.enrolled?(record.course)
  end

  def user_is_instructor?
    user.is_instructor? && (user == record.course.instructor)
  end
end
