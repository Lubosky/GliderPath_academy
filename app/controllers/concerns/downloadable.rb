module Downloadable
  extend ActiveSupport::Concern

  def send_to_user(attachment)
    file = Refile.store.get(attachment.file_id).download
    if Upload.exists?(attachment.id)
      send_file file, filename: attachment.file_filename, type: attachment.file_content_type, disposition: :attachment
    else
      flash[:notice] = t('flash.attachments.error')
      redirect_to :back
    end
  end

end
