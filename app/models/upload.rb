class Upload < ApplicationRecord
  belongs_to :user, inverse_of: :uploads

  has_many :lesson_uploads, dependent: :destroy, inverse_of: :uploads
  has_many :lessons, through: :lesson_uploads, inverse_of: :uploads

  before_validation :set_user_id

  attachment :file

  def basename
    File.basename(file_filename, extension)
  end

  def extension
    File.extname(file_filename)
  end

  private

    def set_user_id
      self.user_id = User.current.id
    end

end
