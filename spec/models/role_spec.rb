require 'spec_helper'

describe Role, type: :model do
  describe 'validations' do
    it 'associates with' do
      is_expected.to validate_presence_of(:name)
    end
  end
end
