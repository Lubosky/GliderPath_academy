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
      is_expected.to validate_numericality_of(:price)
        .is_greater_than_or_equal_to(0)
      is_expected.to validate_numericality_of(:price)
        .is_less_than_or_equal_to(9999.99)

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

  context 'scope' do
    it 'returns array of courses based on status' do
      draft = create(:course, published_at: nil,
                              status: Course::DRAFT)
      published = create(:course, published_at: 1.hour.ago,
                                  status: Course::PUBLISHED)
      scheduled = create(:course, published_at: Time.current + 1.week,
                                  status: Course::SCHEDULED)
      courses = Course.all

      expect(courses.draft.map(&:id)).to match_array([draft.id])
      expect(courses.published.map(&:id)).to match_array([published.id])
      expect(courses.scheduled.map(&:id)).to match_array([scheduled.id])
    end
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
end
