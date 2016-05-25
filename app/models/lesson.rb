class Lesson < ApplicationRecord
  validates :title, presence: true

  belongs_to :section, inverse_of: :lessons, foreign_key: :section_id

  has_many :lesson_uploads, dependent: :destroy, inverse_of: :lesson
  has_many :uploads, through: :lesson_uploads

  has_one :course, through: :section

  accepts_nested_attributes_for :lesson_uploads, reject_if: :all_blank, allow_destroy: true
  accepts_attachments_for :uploads, append: true

end
