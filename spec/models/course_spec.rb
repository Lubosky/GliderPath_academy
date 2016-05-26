require 'spec_helper'

describe Course, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)
      is_expected.to validate_presence_of(:user_id)

      is_expected.to have_many :sections
      is_expected.to have_many :lessons

      is_expected.to belong_to :user
    end
  end
end
