class Purchase < ApplicationRecord
  belongs_to :purchasable, polymorphic: true
  belongs_to :purchaser, foreign_key: :purchaser_id, class_name: 'User'

  validates :purchaser_id, uniqueness: { scope: [:purchasable_id, :purchasable_type] }

  attr_accessor :stripe_token, :product_name, :product_price

  def fulfill
    transaction do
      create_purchase
    end
  end

  private

  def create_purchase
    if create_stripe_charge && save
      self.stripe_charge_id = stripe_charge.id
      save!
    end
  end

  def create_stripe_charge
    stripe_charge.create
  end

  def stripe_charge
    @stripe_charge ||= StripeCharge.new(self)
  end
end
