class Upload < ApplicationRecord
  has_many :lesson_uploads, dependent: :destroy, inverse_of: :uploads
  has_many :lessons, through: :lesson_uploads, inverse_of: :uploads

  attachment :file

  def basename
    File.basename(file_filename, extension)
  end

  def extension
    File.extname(file_filename)
  end

end
