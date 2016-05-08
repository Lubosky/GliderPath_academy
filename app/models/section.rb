class Section < ApplicationRecord
  validates :title, presence: true

  belongs_to :course, inverse_of: :sections, foreign_key: :course_id
  has_many :lessons, autosave: true, dependent: :destroy, inverse_of: :section

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true
end
