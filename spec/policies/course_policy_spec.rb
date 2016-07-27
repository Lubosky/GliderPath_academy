require 'spec_helper'
require 'pundit/rspec'

RSpec.describe CoursePolicy do

  let(:admin) { create(:user, :admin) }
  let(:instructor) { create(:user, :instructor) }
  let(:student) { create(:user) }

  subject { described_class }

  permissions :new?, :create? do

    it 'denies access if user is a student' do
      expect(subject).not_to permit(student, Course)
    end

    it 'grants access if user is an admin or an instructor' do
      expect(subject).to permit(admin, Course)
      expect(subject).to permit(instructor, Course)
    end

  end

  permissions :show? do
    it 'grants access to student' do
      expect(subject).to permit(student, Course)
    end
  end

  before do
    @c1 = build_stubbed(:course, instructor: instructor)
    @c2 = build_stubbed(:course, instructor: admin)
  end

  permissions :update?, :edit?, :sort? do

    it 'denies access if user is a student' do
      expect(subject).not_to permit(student, Course)
    end

    it 'grants access if user is an admin or instructor' do
      expect(subject).to permit(admin, Course)
      expect(subject).to permit(instructor, @c1)
    end

    it 'denies access if course does not belong to instructor' do
      expect(subject).not_to permit(instructor, @c2)
    end

  end

  permissions :destroy? do

    it 'denies access if user is a student or an instructor' do
      expect(subject).not_to permit(student, Course)
      expect(subject).not_to permit(instructor, Course)
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(admin, Course)
    end

  end

  before do
    @course = create(:course)
    @student = create(:user)
    @enrollment = create(:enrollment, student_id: @student.id, course_id: @course.id)
  end

  permissions :progress? do

    it 'denies access if student is not enrolled' do
      expect(subject).not_to permit(student, @course)
    end

    it 'grants access if student is enrolled' do
      expect(subject).to permit(@student, @course)
    end

  end

end
