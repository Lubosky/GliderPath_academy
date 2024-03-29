class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :check_if_eligible_to_enroll
  before_action :check_if_student_enrolled

  def create
    authorize :enrollment
    @enrollment = current_user.enroll(@course)

    if @enrollment.save && @enrollment.activate
      flash[:success] = t('flash.enrollments.success', course: @course.name)
      analytics.track_course_enrolled(analytics_metadata_for_enrollment)
      redirect_to course_lesson_path(@course, @course.lessons.first)
    else
      flash[:danger] = t('flash.enrollments.error')
      redirect_to root_path
    end
  end

  private

  def set_course
    @course = Course.find_by_slug(params[:course_id])
  end

  def check_if_eligible_to_enroll
    unless (current_user.has_active_subscription? || current_user.purchased?(@course))
      flash[:warning] = t('flash.enrollments.notice')
      redirect_back(fallback_location: root_path)
    end
  end

  def check_if_student_enrolled
    if current_user.enrolled?(@course)
      flash[:warning] = t('flash.enrollments.alert')
      redirect_back(fallback_location: root_path)
    end
  end

  def analytics_metadata_for_enrollment
    {
      course: @course.name
    }
  end
end
