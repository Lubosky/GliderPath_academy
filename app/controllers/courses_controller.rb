class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :progress]

  def index
    @courses = Course.published.ordered.all
    authorize @courses
  end

  def show
    @sections = @course.modules
  end

  def new
    @course = current_user.courses_as_instructor.build
    authorize @course
  end

  def create
    @course = current_user.courses_as_instructor.build(course_params)
    authorize @course
    if @course.save
      redirect_to @course
      flash[:success] = t('flash.courses.create.success')
    else
      flash[:alert] = t('flash.courses.create.alert')
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to @course
      flash[:success] = t('flash.courses.update.success')
    else
      flash[:alert] = t('flash.courses.update.alert')
      render :edit
    end
  end

  def destroy
    @course.destroy
      flash[:info] = t('flash.courses.destroy.info')
      redirect_to root_path
  end

  def progress
    @sections = @course.modules
  end

  def sort
    authorize :course
    if params[:sort_sections]
      params[:sort_sections].each do |key, value|
        Section.find(value[:section_id]).update_attribute(:position, value[:position])
      end
      params[:sort_lessons].each do |key, value|
        Lesson.find(value[:lesson_id]).update_attribute(:position, value[:position])
      end
    elsif params[:lesson_order]
      params[:lesson_order].each do |key, value|
        Lesson.find(value[:id]).update(section_id: value[:section_id], position: value[:position])
      end
    end
    head :ok
  end

  private

  def set_course
    @course ||= Course.includes(:instructor, :video).find_by_slug(params[:id])
    authorize @course
  end

  def course_params
    params.require(:course).permit(:name, :status, :published_at, :short_description, :description, :price,
      video_attributes: [ :id, :video_url ],
      sections_attributes: [ :id, :title, :objective, :_destroy,
        lessons_attributes: [ :id, :title, :notes, :_destroy,
          video_attributes: [ :id, :video_url ],
          uploads_attributes: [ :id, :_destroy ],
          uploads_files: [ ]
        ]
      ]
    )
  end
end
