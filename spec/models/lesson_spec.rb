require 'spec_helper'

describe Lesson, type: :model do
  describe 'validations' do
    it 'associates with' do
      is_expected.to validate_presence_of(:title)

      is_expected.to belong_to :course
      is_expected.to belong_to :section
    end
  end
end
