class Lesson < ApplicationRecord
  validates :title, presence: true

  belongs_to :section, inverse_of: :lessons, foreign_key: :section_id
  has_one :course, through: :section
end
