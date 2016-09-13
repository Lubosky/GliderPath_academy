class WorkshopsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_workshop, only: [:show, :edit, :update, :destroy]

  def index
    authorize workshops
  end

  def show
  end

  def new
    @workshop = current_user.workshops.build
    authorize @workshop
  end

  def create
    @workshop = current_user.workshops.build(workshop_params)
    authorize @workshop
    if @workshop.save
      redirect_to @workshop
      flash[:success] = t('flash.workshops.create.success')
    else
      flash[:alert] = t('flash.workshops.create.alert')
      render :new
    end
  end

  def edit
  end

  def update
    if workshop.update(workshop_params)
      redirect_to workshop
      flash[:success] = t('flash.workshops.update.success')
    else
      flash[:alert] = t('flash.workshops.update.alert')
      render :edit
    end
  end

  def destroy
    workshop.destroy
    flash[:info] = t('flash.workshops.destroy.info')
    redirect_to root_path
  end

  private

  def workshop
    @workshop ||=
      Workshop.includes(:instructor, :uploads, :video).find_by_slug(params[:id])
  end
  helper_method :workshop

  def workshops
    @workshops ||= Workshop.published.ordered.includes(:instructor, :video).all
  end
  helper_method :workshops

  def authorize_workshop
    authorize workshop
  end

  def workshop_params
    params.require(:workshop).permit(:name, :status, :published_at, :short_description, :notes, :price,
      video_attributes: [:id, :video_url],
      uploads_attributes: [:id, :_destroy],
      uploads_files: []
    )
  end
end
