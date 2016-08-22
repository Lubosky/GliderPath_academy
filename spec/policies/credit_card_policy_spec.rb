require 'spec_helper'
require 'pundit/rspec'

RSpec.describe CreditCardPolicy do
  let(:user) { build_stubbed(:user, stripe_customer_id: Stripe::Customer) }

  subject { described_class }

  permissions :update? do
    it 'allows user to update default credit card' do
      expect(subject).to permit(user)
    end
  end
end
