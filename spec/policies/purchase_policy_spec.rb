require 'spec_helper'

RSpec.describe PurchasePolicy do

  let(:u1) { build_stubbed(:user) }
  let(:u2) { build_stubbed(:user) }

  subject { described_class }

  before do
    subscription = build_stubbed(:subscription, subscriber: u1)
  end

  permissions :new? do
    it 'denies user to purchase if user already subscribed' do
      expect(subject).not_to permit(u1)
    end

    it 'allows user to purchase if user not subscribed' do
      expect(subject).to permit(u2)
    end
  end

end
