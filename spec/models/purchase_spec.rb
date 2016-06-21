require 'spec_helper'

describe Purchase, type: :model do
  describe 'validations' do

    subject { create :purchase, :course_purchase }

    it 'validates and associates with' do
      is_expected.to belong_to :purchasable
      is_expected.to belong_to :purchaser

      is_expected.to validate_uniqueness_of(:purchaser_id).scoped_to(:purchasable_id, :purchasable_type)
    end

  end
end
