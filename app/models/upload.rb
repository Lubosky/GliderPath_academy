class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  belongs_to :uploader, foreign_key: :uploader_id, class_name: 'User'

  before_save :set_uploader_id

  attachment :file, extension: [ 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'pdf', 'zip', 'jpg', 'jpeg', 'png', 'gif' ]

  validates_presence_of :file
  validates :file_size, numericality: { less_than_or_equal_to: 5.megabytes }

  def extension
    File.extname(file_filename).delete('.')
  end

  private

  def set_uploader_id
    self.uploader_id = User.current.id
  end
end
