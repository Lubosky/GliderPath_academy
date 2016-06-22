require 'spec_helper'

describe Charge, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:user_id)
      is_expected.to validate_uniqueness_of(:braintree_transaction_id)
    end
  end
end
