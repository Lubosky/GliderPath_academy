class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: [:download]

  include Downloadable

  def download
    authorize @upload
    send_to_user(@upload)
  end

  private

    def set_upload
      @upload = Upload.find(params[:id])
    end

end
