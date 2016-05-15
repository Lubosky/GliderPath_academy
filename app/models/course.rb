class Course < ActiveRecord::Base
  belongs_to :user, inverse_of: :courses

  validates :name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_many :sections, autosave: true, dependent: :destroy, inverse_of: :course
  has_many :lessons, through: :sections

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
end
