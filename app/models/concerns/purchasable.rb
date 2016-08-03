module Concerns
  module Purchasable
    extend ActiveSupport::Concern

    included do
      has_many :purchases, as: :purchasable
      has_many :purchasers, through: :purchases, as: :purchasable, foreign_key: :purchaser_id, class_name: 'User'
    end

  end
end
