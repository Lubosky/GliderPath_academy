require 'spec_helper'

describe Upload, type: :model do

  describe 'validations' do

    it 'validates and associates with' do
      is_expected.to belong_to :uploadable
      is_expected.to belong_to :uploader
    end
  end
end
