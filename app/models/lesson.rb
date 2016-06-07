class Lesson < ApplicationRecord
  validates :title, presence: true

  belongs_to :section, inverse_of: :lessons, foreign_key: :section_id

  has_many :enrolled_lessons, inverse_of: :lesson, dependent: :destroy, foreign_key: :lesson_id
  has_many :students, through: :enrolled_lessons, class_name: 'User', foreign_key: :student_id
  has_many :lesson_uploads, dependent: :destroy, inverse_of: :lesson
  has_many :uploads, through: :lesson_uploads

  has_one :course, through: :section

  accepts_nested_attributes_for :lesson_uploads, reject_if: :all_blank, allow_destroy: true
  accepts_attachments_for :uploads, append: true

end
