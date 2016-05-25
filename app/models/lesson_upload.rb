class LessonUpload < ApplicationRecord
  belongs_to :lesson, inverse_of: :lesson_uploads
  belongs_to :upload
end
