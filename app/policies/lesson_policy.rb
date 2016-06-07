class LessonPolicy < ApplicationPolicy

  def show?
    return true if user.present? && user.enrolled?(record.course)
  end

  def complete?
    show?
  end

end
