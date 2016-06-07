class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:show, :complete]

  def show
    authorize @lesson
    enrolled_lesson = current_user.enrolled_lessons.find_or_initialize_by(lesson: @lesson)
    enrolled_lesson.activate && enrolled_lesson.save
  end

  def complete
    authorize @lesson
    enrolled_lesson = current_user.enrolled_lessons.find_by(lesson_id: @lesson.id)
    enrolled_lesson.complete
    redirect_back(fallback_location: root_path)
  end

  private

    def set_lesson
      @course = Course.find(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
    end

end
