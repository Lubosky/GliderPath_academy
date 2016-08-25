require 'spec_helper'
require 'pundit/rspec'

RSpec.describe LessonPolicy do
  subject { described_class }

  before do
    @course = create(:course)
    @section = create(:section, course: @course)
    @lesson = create(:lesson, section: @section)
  end

  permissions :show? do
    it 'grants access to enrolled student if user has active subscription' do
      user = create(:user, :with_subscription)
      user.enroll(@course)

      expect(subject).to permit(user, @lesson)
    end

    it 'denies access if student does not have active subscription' do
      user = build_stubbed(:user)

      expect(subject).not_to permit(user, @lesson)
    end

    it 'denies access if student not enrolled' do
      user = build_stubbed(:user, :with_subscription)

      expect(subject).not_to permit(user, @lesson)
    end
  end
end
