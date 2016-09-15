class InstructorDashboard
  def initialize(user)
    @user = user
  end

  def courses
    Course.where(instructor_id: user.id).all
  end

  def workshops
    Workshop.where(instructor_id: user.id).includes(:video).all
  end

  def enrollment_count
    courses.joins(:enrollments).group('courses.id').count
  end

  def purchase_count
    workshops.joins(:purchases).group('workshops.id').count
  end

  private

  attr_reader :user
end
