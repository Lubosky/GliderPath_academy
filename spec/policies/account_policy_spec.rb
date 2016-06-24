require 'spec_helper'
require 'pundit/rspec'

RSpec.describe AccountPolicy do
  let(:u1) { build_stubbed(:user) }
  let(:u2) { build_stubbed(:user) }

  subject { described_class }

  permissions :show? do
    it 'allows user to access his own profile' do
      expect(subject).to permit(u1)
      expect(subject).not_to permit(nil)
    end
  end

  permissions :edit? do
    it 'allows user to edit his own profile' do
      expect(subject).to permit(u1)
    end
  end

  permissions :update_account? do
    it 'allows user to update his own profile' do
      expect(subject).to permit(u1)
    end
  end
end
