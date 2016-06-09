require 'spec_helper'

describe Section, type: :model do
  describe 'validations' do

    subject { create :section }

    it 'validates and associates with' do
      is_expected.to validate_presence_of(:title)
      is_expected.to validate_presence_of(:position)

      is_expected.to belong_to :course
      is_expected.to have_many :lessons
    end
  end
end
