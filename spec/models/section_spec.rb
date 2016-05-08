require 'spec_helper'

describe Section, type: :model do
  describe 'validations' do
    it 'associates with' do
      is_expected.to validate_presence_of(:title)

      is_expected.to belong_to :course
    end
  end
end
