module Downloadable
  extend ActiveSupport::Concern

  def send_to_user(attachment)
    file = attachment.file
    if file.exists?
      send_file file.download, filename: file.original_filename,
                               type: file.mime_type,
                               disposition: :attachment
    else
      flash[:notice] = t('flash.attachments.error')
      redirect_back(fallback_location: root_path)
    end
  end
end
