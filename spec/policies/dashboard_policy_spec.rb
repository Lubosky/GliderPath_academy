require 'spec_helper'

RSpec.describe DashboardPolicy do

  let(:user) { build_stubbed(:user) }

  subject { described_class }

  permissions :show? do
    it 'allows user to access dashboard' do
      expect(subject).to permit(user)
      expect(subject).not_to permit(nil)
    end
  end
end
