module Concerns
  module Purchasable
    extend ActiveSupport::Concern

    included do
      has_many :purchases, as: :purchasable, inverse_of: :purchasable
      has_many :purchasers, through: :purchases, as: :purchasable, inverse_of: :purchasable
    end

  end
end
