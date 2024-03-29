require 'spec_helper'

RSpec.describe EnrollmentPolicy do

  let(:user) { build_stubbed(:user) }

  subject { described_class }

  permissions :create? do
    it 'allows user to enroll if user present' do
      expect(subject).to permit(user)
    end
  end

end
