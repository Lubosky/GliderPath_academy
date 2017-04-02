class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  belongs_to :uploader, foreign_key: :uploader_id, class_name: 'User'

  # before_save :set_uploader_id

  before_save do
    write_shrine_data(:file) if changes.key?(:file_id)
  end

  attachment :file, extension: [ 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'pdf', 'zip', 'jpg', 'jpeg', 'png', 'gif' ]

  validates_presence_of :file
  validates :file_size, numericality: { less_than_or_equal_to: 5.megabytes }

  def write_shrine_data(name)
    if read_attribute("#{name}_id").present?
      data = {
        storage: :store,
        id: send("#{name}_id"),
        metadata: {
          size: (send("#{name}_size") if respond_to?("#{name}_size")),
          filename: (send("#{name}_filename") if respond_to?("#{name}_filename")),
          mime_type: (send("#{name}_content_type") if respond_to?("#{name}_content_type")),
        }
      }
      write_attribute(:"#{name}_data", data.to_json)
    else
      write_attribute(:"#{name}_data", nil)
    end
  end

  def extension
    File.extname(file_filename).delete('.')
  end

  private

  def set_uploader_id
    self.uploader_id = User.current.id
  end
end
