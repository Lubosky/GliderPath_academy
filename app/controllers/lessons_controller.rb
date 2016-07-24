class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:show, :complete]

  def show
    enrolled_lesson = current_user.enrolled_lessons.find_or_initialize_by(lesson: @lesson)
    enrolled_lesson.activate && enrolled_lesson.save
  end

  def complete
    enrolled_lesson = current_user.enrolled_lessons.find_by(lesson_id: @lesson.id)
    enrolled_lesson.complete
    @next_lesson = @lesson.next_lesson
    if @next_lesson == nil
      flash[:success] = t('flash.courses.complete', course: @course.name)
      redirect_back(fallback_location: course_lesson_path(@course, @lesson))
    else
      redirect_to course_lesson_path(@course, @next_lesson)
    end
  end

  private

    def set_lesson
      @course = Course.find_by_slug(params[:course_id])
      @lesson = @course.lessons.find(params[:id])
      authorize @lesson
    end

end
