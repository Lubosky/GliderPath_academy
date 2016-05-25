class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course, only: [:show, :edit, :update, :destroy]
  before_action :owned_course, only: [:edit, :update]

  def index
    @courses = Course.all.order('created_at DESC')
    authorize @courses
  end

  def show
  end

  def new
    @course = current_user.courses.build
    authorize @course
  end

  def create
    @course = current_user.courses.build(course_params)
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
      params.require(:course).permit(:name, :description, sections_attributes: [ :id, :title, :objective, :_destroy, lessons_attributes: [ :id, :title, :notes, :_destroy, lesson_uploads_attributes: [ :id, :_destroy ], uploads_files: [ ] ] ])
    end

    def owned_course
      unless current_user == @course.user
        flash[:alert] = t('flash.courses.update.not_authorized')
        redirect_to :back
      end
    end

end
