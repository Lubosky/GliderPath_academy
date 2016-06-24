require 'spec_helper'

RSpec.describe SubscriptionPolicy do

  let(:u1) { build_stubbed(:user) }
  let(:u2) { build_stubbed(:user) }

  subject { described_class }

  before :each do
    subscription = build_stubbed(:subscription, subscriber: u2)
  end

  permissions :new? do
    it 'allows user to subscribe if user present' do
      expect(subject).to permit(u1)
    end
  end

  permissions :create? do
    it 'allows user to subscribe if user present' do
      expect(subject).to permit(u1)
    end
  end

  permissions :destroy? do
    it 'denies user to cancel the subscription if subscription not active' do
      expect(subject).not_to permit(u1)
    end

    it 'allows user to cancel the subscription if subscription active' do
      expect(subject).to permit(u2)
    end
  end

end
