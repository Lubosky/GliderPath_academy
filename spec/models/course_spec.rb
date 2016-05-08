require 'spec_helper'

describe Course, type: :model do
  describe 'validations' do
    it 'associates with' do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)

      is_expected.to have_many :sections
    end
  end
end
