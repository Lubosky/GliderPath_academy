require 'spec_helper'
require 'pundit/rspec'

RSpec.describe ChargePolicy do
  let(:u1) { build_stubbed(:user) }
  let(:u2) { build_stubbed(:user) }
  let(:scope) { Charge.where(user_id: u1.id) }

  subject(:policy_scope) { ChargePolicy::Scope.new(u1, scope).resolve }

  permissions '.scope' do
    context 'for an user' do

      it 'shows charges belonging to user' do
        charge = Charge.create(user_id: u1.id)
        expect(policy_scope).to eq [charge]
      end

      it 'hides charges not belonging to user' do
        charge = Charge.create(user_id: u2.id)
        expect(policy_scope).to eq []
      end
    end
  end
end
