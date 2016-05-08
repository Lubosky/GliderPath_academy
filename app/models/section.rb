class Section < ApplicationRecord
  validates :title, presence: true

  belongs_to :course, inverse_of: :sections
end
