class UploadsController < ApplicationController
  before_action :authenticate_user!

  include Downloadable

  def download
    authorize attachment
    send_to_user(attachment)
    analytics.track_downloaded(analytics_metadata_for_download)
  end

  private

    def attachment
      Upload.find(params[:id])
    end
    helper_method :attachment

    def analytics_metadata_for_download
      {
        file: attachment.file_filename,
        type: attachment.uploadable_type,
        source: attachment.uploadable_id
      }
    end

end
