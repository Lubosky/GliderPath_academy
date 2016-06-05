require 'spec_helper'

describe Enrollment, type: :model do
  describe 'validations' do
    it 'validates and associates with' do

      is_expected.to validate_presence_of(:course_id)
      is_expected.to validate_presence_of(:student_id)

    end
  end
end
