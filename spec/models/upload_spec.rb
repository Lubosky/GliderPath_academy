require 'spec_helper'

describe Upload, type: :model do

  describe 'validations' do

    let(:user) { create(:user) }

    it 'validates and associates with' do
      RequestStore.store[:current_user] = user
      is_expected.to have_many :lessons
      is_expected.to have_many :lesson_uploads
      is_expected.to belong_to :user

      is_expected.to validate_presence_of(:file)
      is_expected.to validate_numericality_of(:file_size).is_less_than_or_equal_to(5.megabytes)
    end
  end
end
