require 'spec_helper'

RSpec.describe ForumSessionPolicy do

  let(:user) { build_stubbed(:user) }

  subject { described_class }

  permissions :new? do
    it 'grants access to forum if user signed in' do
      expect(subject).to permit(user)
    end

    it 'denies access to forum if user not signed in' do
      expect(subject).to permit(user)
    end
  end

end
