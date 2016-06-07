require 'spec_helper'

describe Enrollment, type: :model do

  describe 'validations' do
    it 'validates and associates with' do

      is_expected.to validate_presence_of(:course_id)
      is_expected.to validate_presence_of(:student_id)

    end
  end

  describe 'set enrollment status to "Active" automatically after student enrolls in course' do
    let(:u2) { create(:user) }
    let(:course) { create(:course) }
    let(:enrollment) { create(:enrollment, student_id: u2.id, course_id: course.id) }

    it { expect { enrollment.activate }.to change(enrollment, :status).from('initial').to('active') }
  end

end
