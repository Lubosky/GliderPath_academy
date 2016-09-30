require 'spec_helper'
require 'pundit/rspec'

RSpec.describe LessonPolicy do
  subject { described_class }

  permissions :show? do
    it 'grants access to enrolled student if user has active subscription' do
      user = create(:user, :with_subscription)
      lesson = stub_lesson
      allow(user).to receive(:enrolled?).and_return(true)

      expect(subject).to permit(user, lesson)
    end

    it 'grants access to enrolled student' do
      user = create(:user)
      lesson = stub_lesson
      allow(user).to receive(:enrolled?).and_return(true)

      expect(subject).to permit(user, lesson)
    end

    it 'denies access if student does not have active subscription' do
      user = build_stubbed(:user)
      lesson = stub_lesson
      allow(user).to receive(:enrolled?).and_return(false)

      expect(subject).not_to permit(user, lesson)
    end

    it 'denies access if student not enrolled' do
      user = build_stubbed(:user, :with_subscription)
      lesson = stub_lesson
      allow(user).to receive(:enrolled?).and_return(false)

      expect(subject).not_to permit(user, lesson)
    end
  end

  permissions :preview? do
    it 'grants access to lesson if user is admin or course instructor' do
      admin = create(:user, :admin)
      instructor = create(:user, :instructor)
      lesson =
        create(:lesson, section:
          create(:section, course:
            create(:course, instructor: instructor)
          )
        )

      expect(subject).to permit(admin, lesson)
      expect(subject).to permit(instructor, lesson)
    end
  end

  def stub_lesson
    lesson = build_stubbed(:lesson)
    allow(Lesson).to receive(:find_by).and_return(lesson)
    lesson
  end
end
