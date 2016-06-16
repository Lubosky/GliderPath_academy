require 'spec_helper'

RSpec.describe EnrollmentPolicy do

  let(:u1) { create(:user) }
  let(:u2) { create(:user) }

  subject { described_class }

  before do
    subscription = build(:subscription, subscriber: u1)
  end

  permissions :create? do
    it 'denies user to enroll to the course if user not subscribed' do
      expect(subject).not_to permit(u2)
    end

    it 'allows user to enroll to the course if user subscribed' do
      expect(subject).to permit(u1)
    end
  end

end
