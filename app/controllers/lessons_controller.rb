class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:show, :complete]

  def show
    enrolled_lesson = current_user.enrolled_lessons.find_or_initialize_by(lesson: @lesson)
    enrolled_lesson.activate && enrolled_lesson.save
    analytics.track_lesson_started(analytics_metadata_for_lesson)
  end

  def complete
    enrolled_lesson = current_user.enrolled_lessons.find_by(lesson_id: @lesson.id)
    enrolled_lesson.complete
    analytics.track_lesson_completed(analytics_metadata_for_lesson)
    @next_lesson = @lesson.next_lesson
    if @next_lesson.nil?
      flash[:success] = t('flash.courses.complete', course: @course.name)
      analytics.track_course_completed(analytics_metadata_for_course)
      redirect_back(fallback_location: course_lesson_path(@course, @lesson))
    else
      redirect_to course_lesson_path(@course, @next_lesson)
    end
  end

  private

  def set_lesson
    @course = Course.find_by_slug(params[:course_id])
    @lesson = @course.lessons.find_by_slug(params[:id])
    authorize @lesson
  end

  def analytics_metadata_for_course
    {
      course: @course.name
    }
  end

  def analytics_metadata_for_lesson
    {
      course: @course.name,
      lesson: @lesson.title
    }
  end
end
