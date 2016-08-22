require 'spec_helper'

RSpec.describe ReactivationPolicy do
  let(:user) { build_stubbed(:user) }

  subject { described_class }

  before :each do
    build_stubbed(:subscription, subscriber: user)
  end

  permissions :create? do
    it 'allows user to reactivate subscription' do
      expect(subject).to permit(user)
    end
  end
end
