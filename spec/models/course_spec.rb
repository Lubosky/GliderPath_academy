require 'spec_helper'

describe Course, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:short_description)
      is_expected.to validate_presence_of(:description)
      is_expected.to validate_presence_of(:instructor_id)
      is_expected.to validate_presence_of(:price)
      is_expected.to validate_presence_of(:slug)
      is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0)
      is_expected.to validate_numericality_of(:price).is_less_than_or_equal_to(9999.99)

      is_expected.to have_many :sections
      is_expected.to have_many :lessons
      is_expected.to have_many :purchases
      is_expected.to have_many :purchasers
      is_expected.to have_many :uploads

      is_expected.to belong_to :instructor
    end
  end

  context 'uniqueness' do
    before do
      create :course
    end

    it { is_expected.to validate_uniqueness_of(:slug) }
  end

  describe '#first_remaining_lesson_for' do
    it 'returns the first remaining lesson in the course for the user' do
      course = create(:course)
      section = create(:section, course: course)
      completed = create(:lesson, section: section, position: 1)
      remaining = create(:lesson, section: section, position: 2)
      user = create(:user)
      create(
        :enrolled_lesson,
        lesson: completed,
        student: user,
        status: 'completed'
      )

      result = course.first_remaining_lesson_for(user)

      expect(result).to eq(remaining)
    end
  end

  describe '#lessons_completed_for' do
    it 'returns completed lessons for a given course and user' do
      course = create(:course)
      section = create(:section, course: course)
      l1 = create(:lesson, section: section)
      l2 = create(:lesson, section: section)
      l3 = create(:lesson, section: section)
      l4 = create(:lesson, section: section)
      user = create(:user)
      create(
        :enrolled_lesson,
        lesson: l1,
        student: user,
        status: 'completed'
      )
      create(
        :enrolled_lesson,
        lesson: l4,
        student: user,
        status: 'completed'
      )

      result = course.lessons_completed_for(user)

      expect(result.map(&:id)).to match_array([l1.id,l4.id])
    end
  end

  describe '.enrolled_courses_for' do
    it 'shows enrolled courses for a user' do
      enrolled = create(:course)
      course = create(:course)
      user = create(:user)
      create(
        :enrollment,
        course_id: enrolled.id,
        student: user
      )

      result = Course.enrolled_courses_for(user)

      expect(result.map(&:id)).to match_array([enrolled.id])
    end
  end

  describe '.accessible_courses_for' do
    it 'shows accessible courses for a user' do
      enrolled = create(:course)
      accessible = create(:course)
      course = create(:course)
      user = create(:user)
      create(
        :enrollment,
        course_id: enrolled.id,
        student: user
      )
      create(
        :purchase,
        purchasable: accessible,
        purchaser: user
      )

      result = Course.accessible_courses_for(user)

      expect(result.map(&:id)).to match_array([accessible.id])
    end
  end

  describe '.available_courses_for' do
    it 'shows available courses for a user' do
      enrolled = create(:course)
      purchased = create(:course)
      course = create(:course)
      user = create(:user)
      create(
        :enrollment,
        course_id: enrolled.id,
        student: user
      )
      create(
        :purchase,
        purchasable: purchased,
        purchaser: user
      )

      result = Course.available_courses_for(user)

      expect(result.map(&:id)).to match_array([course.id])
    end
  end

end
