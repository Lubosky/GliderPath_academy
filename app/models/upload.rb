class Upload < ApplicationRecord
  belongs_to :user, inverse_of: :uploads

  has_many :lesson_uploads, dependent: :destroy, inverse_of: :uploads
  has_many :lessons, through: :lesson_uploads, inverse_of: :uploads

  before_validation :set_user_id

  attachment :file, extension: [ 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'pdf', 'zip', 'jpg', 'jpeg', 'png', 'gif' ]

  validates_presence_of :file
  validates :file_size, numericality: { less_than_or_equal_to: 5.megabytes }
  validates :user_id, presence: true

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
