class Purchase < ApplicationRecord
  belongs_to :purchasable, polymorphic: true
  belongs_to :purchaser, foreign_key: :purchaser_id, class_name: 'User'

  validates :purchaser_id, uniqueness: { scope: [ :purchasable_id, :purchasable_type ] }
end
