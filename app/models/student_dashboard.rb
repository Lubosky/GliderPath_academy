class StudentDashboard
  def initialize(user)
    @user = user
  end

  def accessible
    accessible_courses.includes(:instructor)
  end

  def available
    available_courses.ordered.includes(:instructor)
  end

  def enrolled
    enrolled_courses.includes(:instructor)
  end

  private

  attr_reader :user

  def courses
    Course.published.all
  end

  def accessible_courses
    courses.joins(:purchases).
    where(purchases: { purchaser: user }).
    where.not(id: enrolled_courses).
    order('purchases.created_at desc')
  end

  def available_courses
    courses.where.not(id: accessible_courses).
    where.not(id: enrolled_courses)
  end

  def enrolled_courses
    courses.joins(:enrollments).
    where(enrollments: { student: user }).
    order('enrollments.created_at desc')
  end
end
