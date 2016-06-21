class Purchase < ApplicationRecord
  belongs_to :purchasable, inverse_of: :purchases, polymorphic: true
  belongs_to :purchaser, inverse_of: :purchases, class_name: 'User'

  validates :purchaser_id, uniqueness: { scope: [ :purchasable_id, :purchasable_type ] }
end
