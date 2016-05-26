require 'spec_helper'

RSpec.describe UploadPolicy do

  let(:user) { FactoryGirl.create(:user) }

  subject { described_class }

  permissions :download? do
    it 'grants access to user' do
      expect(subject).to permit(user)
    end
  end

end
