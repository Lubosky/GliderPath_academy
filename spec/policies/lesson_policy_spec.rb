require 'spec_helper'

RSpec.describe LessonPolicy do

  let(:user) { FactoryGirl.create(:user) }

  subject { described_class }

  permissions :show? do
    it 'grants access to student' do
      expect(subject).to permit(user)
    end
  end

end
