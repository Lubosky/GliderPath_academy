class UploadsController < ApplicationController
  before_action :authenticate_user!

  include Downloadable

  def download
    upload = Upload.find(params[:id])
    authorize upload
    send_to_user(upload)
  end

end
