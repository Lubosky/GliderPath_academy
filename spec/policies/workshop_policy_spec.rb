require 'spec_helper'
require 'pundit/rspec'

RSpec.describe WorkshopPolicy do

  let(:admin) { create(:user, :admin) }
  let(:instructor) { create(:user, :instructor) }
  let(:user) { create(:user) }

  subject { described_class }

  permissions :new?, :create? do

    it 'denies access if user is not an admin or a instructor' do
      expect(subject).not_to permit(user, Workshop)
    end

    it 'grants access if user is an admin or a instructor' do
      expect(subject).to permit(admin, Workshop)
      expect(subject).to permit(instructor, Workshop)
    end

  end

  permissions :show? do
    it 'grants access to user' do
      expect(subject).to permit(user, Workshop)
    end
  end

  before do
    @w1 = build_stubbed(:workshop, instructor: instructor)
    @w2 = build_stubbed(:workshop, instructor: admin)
  end

  permissions :update?, :edit? do

    it 'denies access if user is a user' do
      expect(subject).not_to permit(user, Workshop)
    end

    it 'grants access if user is an admin or instructor' do
      expect(subject).to permit(admin, Workshop)
      expect(subject).to permit(instructor, @w1)
    end

    it 'denies access if workshop does not belong to instructor' do
      expect(subject).not_to permit(instructor, @w2)
    end

  end

  permissions :destroy? do

    it 'denies access if user is not an admin' do
      expect(subject).not_to permit(user, Workshop)
      expect(subject).not_to permit(instructor, Workshop)
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(admin, Workshop)
    end

  end

end
