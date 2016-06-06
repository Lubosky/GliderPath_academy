require 'spec_helper'
require 'pundit/rspec'

RSpec.describe LessonPolicy do

  let(:instructor) { create(:user, :instructor) }
  let(:u1) { create(:user) }
  let(:u2) { create(:user) }

  subject { described_class }

  before do
    @course = create(:course, instructor: instructor)
    @section = create(:section, course: @course)
    @lesson = create(:lesson, section: @section)
    u1.enroll(@course)
  end

  permissions :show? do
    it 'grants access to enrolled student' do
      expect(subject).to permit(u1, @lesson)
    end

    it 'denies access if student not enrolled' do
      expect(subject).not_to permit(u2, @lesson)
    end
  end

end
