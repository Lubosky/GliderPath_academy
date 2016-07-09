require 'spec_helper'

describe Course, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)
      is_expected.to validate_presence_of(:instructor_id)
      is_expected.to validate_presence_of(:price)
      is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0)
      is_expected.to validate_numericality_of(:price).is_less_than_or_equal_to(9999.99)

      is_expected.to have_many :sections
      is_expected.to have_many :lessons
      is_expected.to have_many :purchases
      is_expected.to have_many :purchasers

      is_expected.to belong_to :instructor
    end
  end
end
