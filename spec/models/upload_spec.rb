require 'spec_helper'

describe Upload, type: :model do

  describe 'validations' do

    it 'validates and associates with' do
      is_expected.to belong_to :uploadable
      is_expected.to belong_to :uploader

      is_expected.to validate_presence_of(:file)
      is_expected.to validate_numericality_of(:file_size).is_less_than_or_equal_to(5.megabytes)
    end
  end
end
