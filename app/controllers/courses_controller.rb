class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :progress]
  before_action :set_sections, only: [:show, :progress]

  def index
    @courses = Course.all.order('created_at DESC')
    authorize @courses
  end

  def show
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
    authorize @course
  end

  private

    def set_course
      @course = Course.find(params[:id])
      authorize @course
    end

    def set_sections
      @sections = @course.sections.includes(lessons: :video)
    end

    def course_params
      params.require(:course).permit(:name, :description, :price, video_attributes: [ :id, :video_url ], sections_attributes: [ :id, :title, :objective, :_destroy, lessons_attributes: [ :id, :title, :notes, :_destroy, video_attributes: [ :id, :video_url ], uploads_attributes: [ :id, :_destroy ], uploads_files: [ ] ] ])
    end

end
