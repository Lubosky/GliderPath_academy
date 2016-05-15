class LessonsController < ApplicationController
  before_action :authenticate_user!

  def show
    course = Course.find(params[:course_id])
    @lesson = course.lessons.find(params[:id])
    authorize @lesson
  end

end
