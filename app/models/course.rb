class Course < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true

  has_many :sections, dependent: :destroy, inverse_of: :course

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true
end
