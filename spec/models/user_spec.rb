require 'spec_helper'

describe User, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:first_name)
      is_expected.to validate_presence_of(:last_name)
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_presence_of(:password)

      is_expected.to have_many :courses_as_instructor
      is_expected.to have_many :courses_as_student
      is_expected.to have_many :enrollments
      is_expected.to have_many :lessons
      is_expected.to have_many :enrolled_lessons
      is_expected.to have_many :uploads
      is_expected.to have_one :subscription
      is_expected.to have_one :plan
    end
  end
end
