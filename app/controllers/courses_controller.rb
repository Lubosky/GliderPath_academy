class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.all.order('created_at DESC')
    authorize @courses
  end

  def show
    @sections = @course.sections.includes(lessons: :video)
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

  private

    def find_course
      @course = Course.find(params[:id])
      authorize @course
    end

    def course_params
      params.require(:course).permit(:name, :description, video_attributes: [ :id, :video_url ], sections_attributes: [ :id, :title, :objective, :_destroy, lessons_attributes: [ :id, :title, :notes, :_destroy, video_attributes: [ :id, :video_url ], lesson_uploads_attributes: [ :id, :_destroy ], uploads_files: [ ] ] ])
    end

end
