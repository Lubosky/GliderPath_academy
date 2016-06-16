require 'spec_helper'

describe Plan, type: :model do
  describe 'validations' do

    it 'validates and associates with' do
      is_expected.to have_many :subscriptions
      is_expected.to have_many :subscribers
    end

  end
end
