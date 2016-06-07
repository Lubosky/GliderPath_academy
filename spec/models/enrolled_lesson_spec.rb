require 'spec_helper'

describe EnrolledLesson, type: :model do
  describe 'validations' do
    it 'validates and associates with' do

      is_expected.to validate_presence_of(:lesson_id)
      is_expected.to validate_presence_of(:student_id)

      is_expected.to belong_to :lesson
      is_expected.to belong_to :student
    end
  end

  describe '#activate' do
    let(:u2) { create(:user) }
    let(:lesson) { create(:lesson) }
    let(:enrolled_lesson) { create(:enrolled_lesson, student_id: u2.id, lesson_id: lesson.id) }

    it { expect { enrolled_lesson.activate }.to change(enrolled_lesson, :status).from('initial').to('active') }
    it { expect { enrolled_lesson.complete }.to_not change(enrolled_lesson, :status) }
  end

  describe '#complete' do
    let(:u2) { create(:user) }
    let(:lesson) { create(:lesson) }
    let(:enrolled_lesson) { create(:enrolled_lesson, student_id: u2.id, lesson_id: lesson.id, status: 'active') }

    it { expect { enrolled_lesson.complete }.to change(enrolled_lesson, :status).from('active').to('completed') }
  end

end
