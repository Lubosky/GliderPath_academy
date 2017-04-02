class Upload < ApplicationRecord
  include FileUploader[:file]

  belongs_to :uploadable, polymorphic: true
  belongs_to :uploader, foreign_key: :uploader_id, class_name: 'User'

  before_save :set_uploader_id

  def extension
    file.extension
  end

  private

  def set_uploader_id
    self.uploader_id = User.current.id
  end
end
