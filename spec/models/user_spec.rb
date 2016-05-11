require 'spec_helper'

describe User, type: :model do
  describe 'validations' do
    it 'associates with' do
      is_expected.to validate_presence_of(:first_name)
      is_expected.to validate_presence_of(:last_name)
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_presence_of(:password)
    end
  end
end
