class LessonUpload < ApplicationRecord
  belongs_to :lesson, inverse_of: :lesson_uploads
  belongs_to :upload, inverse_of: :lesson_uploads

  validates :lesson_id, presence: true
  validates :upload_id, presence: true
end
