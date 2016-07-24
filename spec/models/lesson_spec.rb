require 'spec_helper'

describe Lesson, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:title)
      is_expected.to validate_presence_of(:slug)

      is_expected.to have_one :course
      is_expected.to have_many :enrolled_lessons
      is_expected.to have_many :uploads
      is_expected.to belong_to :section
    end
  end

  context 'uniqueness' do
    before do
      create :lesson
    end

    it { is_expected.to validate_uniqueness_of(:slug) }
  end
  
end
