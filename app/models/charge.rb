class Charge < ApplicationRecord
  belongs_to :user, inverse_of: :uploads

  validates_presence_of :user_id
  validates :braintree_transaction_id, uniqueness: true

  def invoice_number
    "INV-#{self.created_at.strftime('%Y-%m-%d')}-#{self.id}"
  end

end
