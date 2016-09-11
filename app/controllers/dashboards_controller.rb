class DashboardsController < ApplicationController
  before_action :authenticate_user!
  helper_method :available_courses, :accessible_courses, :enrolled_courses

  def show
    authorize :dashboard
  end

  private

  def enrolled_courses
    Course.enrolled_courses_for(current_user).includes(:instructor)
  end

  def accessible_courses
    Course.accessible_courses_for(current_user).includes(:instructor)
  end

  def available_courses
    Course.available_courses_for(current_user).ordered.includes(:instructor)
  end
end
