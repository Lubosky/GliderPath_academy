class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course
  before_action :check_if_eligible_to_enroll
  before_action :check_if_student_enrolled

  def create
    authorize :enrollment
    @enrollment = current_user.enroll(@course)

    if @enrollment.save && @enrollment.activate
      flash[:success] = t('flash.enrollments.success', course: @course.name)
      redirect_to course_lesson_path(@course, @course.lessons.first)
    else
      flash[:danger] = t('flash.enrollments.error')
      redirect_to root_path
    end
  end

  private

    def find_course
      @course = Course.find(params[:course_id])
    end

    def check_if_eligible_to_enroll
      if !( current_user.has_active_subscription? || current_user.purchased?(@course) )
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

end
