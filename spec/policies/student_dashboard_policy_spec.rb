require 'spec_helper'

RSpec.describe StudentDashboardPolicy do
  subject { described_class }

  permissions :show? do
    it 'allows user to access dashboard' do
      student = build_stubbed(:user)

      expect(subject).to permit(student)
    end

    it 'denies access to dashboard if user not signed in' do
      expect(subject).not_to permit(nil)
    end
  end
end
