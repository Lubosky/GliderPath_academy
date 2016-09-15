require 'spec_helper'

RSpec.describe StudentDashboard do
  describe '.enrolled' do
    it 'shows enrolled courses for a user' do
      user = create(:user)
      course = create(:course)
      build_stubbed(:course)
      create(:enrollment, course_id: course.id, student: user)
      dashboard = StudentDashboard.new(user)

      result = dashboard.enrolled

      expect(result.map(&:id)).to match_array([course.id])
    end
  end

  describe '.accessible' do
    it 'shows accessible courses for a user' do
      user = create(:user)
      accessible = create(:course)
      enrolled = create(:course)
      build_stubbed(:course)
      create(:enrollment, course_id: enrolled.id, student: user)
      create(:purchase, purchasable: accessible, purchaser: user)
      dashboard = StudentDashboard.new(user)

      result = dashboard.accessible

      expect(result.map(&:id)).to match_array([accessible.id])
    end
  end

  describe '.available' do
    it 'shows available courses for a user' do
      user = create(:user)
      accessible = create(:course)
      enrolled = create(:course)
      course = create(:course)
      create(:enrollment, course_id: enrolled.id, student: user)
      create(:purchase, purchasable: accessible, purchaser: user)
      dashboard = StudentDashboard.new(user)

      result = dashboard.available

      expect(result.map(&:id)).to match_array([course.id])
    end
  end
end
