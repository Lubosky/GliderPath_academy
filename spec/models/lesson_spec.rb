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

  describe '#set_position' do
    it 'sets position of the lesson' do
      course = create(:course)
      section = create(:section, course: course)
      lessons = create_list(:lesson, 3, section: section)

      lessons.map { |lesson| lesson.reload }

      expect(course.lessons.map(&:position)).to eq([1,2,3])
    end
  end

  describe 'states' do
    it 'returns state of the lesson' do
      l1 = create(:lesson)
      l2 = create(:lesson)
      user = create(:user)
      create(
        :enrolled_lesson,
        lesson: l1,
        student: user,
        status: 'completed'
      )
      create(
        :enrolled_lesson,
        lesson: l2,
        student: user,
        status: 'active'
      )

      expect(l1.completed?(user)).to be_truthy
      expect(l2.completed?(user)).to be_falsy
      expect(l1.active?(user)).to be_falsy
      expect(l2.active?(user)).to be_truthy
    end
  end

  describe '.lessons_completed_for' do
    it 'shows completed lessons for a user' do
      completed = create(:lesson)
      lesson = create(:lesson)
      user = create(:user)
      create(
        :enrolled_lesson,
        lesson: completed,
        student: user,
        status: 'completed'
      )

      result = Lesson.lessons_completed_for(user)

      expect(result.map(&:id)).to match_array([completed.id])
    end
  end

  describe '.lessons_remaining_for' do
    it 'shows remaining lessons for a user' do
      completed = create(:lesson)
      remaining = create(:lesson)
      user = create(:user)
      create(
        :enrolled_lesson,
        lesson: completed,
        student: user,
        status: 'completed'
      )

      result = Lesson.lessons_remaining_for(user)

      expect(result.map(&:id)).to match_array([remaining.id])
    end
  end

end
