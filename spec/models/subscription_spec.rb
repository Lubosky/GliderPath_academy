require 'spec_helper'

describe Subscription, type: :model do
  describe 'validations' do

    it 'validates and associates with' do
      is_expected.to belong_to :plan
      is_expected.to belong_to :subscriber
    end

  end
end
