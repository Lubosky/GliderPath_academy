class CoursesController < ApplicationController
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.order('created_at DESC')
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
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
    end

    def course_params
      params.require(:course).permit(:name, :description)
    end
end
