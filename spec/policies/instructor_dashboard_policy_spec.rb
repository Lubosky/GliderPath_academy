require 'spec_helper'

RSpec.describe InstructorDashboardPolicy do
  subject { described_class }

  permissions :show? do
    it 'allows instructor to access dashboard' do
      instructor = create(:user, :instructor)

      expect(subject).to permit(instructor)
    end

    it 'denies access to dashboard if user is not instructor' do
      student = build_stubbed(:user)

      expect(subject).not_to permit(student)
    end

    it 'denies access to dashboard if user not signed in' do
      expect(subject).not_to permit(nil)
    end
  end
end
