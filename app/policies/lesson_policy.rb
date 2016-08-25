class LessonPolicy < ApplicationPolicy

  def show?
    return true if user.present? && user.has_access_to?(record.course) && user.enrolled?(record.course)
  end

  def complete?
    show?
  end

end
