require 'spec_helper'
require 'pundit/rspec'

RSpec.describe PaymentMethodPolicy do
  let(:user) { build_stubbed(:user) }

  subject { described_class }

  permissions :create? do
    it 'allows user to change default payment method' do
      expect(subject).to permit(user)
    end
  end
end
