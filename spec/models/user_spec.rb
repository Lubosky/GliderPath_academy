require 'spec_helper'

describe User, type: :model do
  describe 'validations' do
    it 'validates and associates with' do
      is_expected.to validate_presence_of(:first_name)
      is_expected.to validate_presence_of(:last_name)
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_presence_of(:password)
      is_expected.to validate_length_of(:headline)
      is_expected.to validate_length_of(:bio)

      is_expected.to have_many :courses_as_instructor
      is_expected.to have_many :courses_as_student
      is_expected.to have_many :enrolled_lessons
      is_expected.to have_many :enrollments
      is_expected.to have_many :lessons
      is_expected.to have_many :purchases
      is_expected.to have_many :uploads
      is_expected.to have_many :workshops
      is_expected.to have_one :subscription
      is_expected.to have_one :plan
    end
  end

  describe '#has_access_to?' do
    context 'when the user does not have a subscription' do
      it 'returns false' do
        user = build_stubbed(:user)

        expect(user).not_to have_access_to(:course)
      end
    end

    context 'when the user has an inactive subscription' do
      it 'returns false' do
        user = create(:user)
        allow(user.subscription).to receive(:active?).and_return(false)

        expect(user).not_to have_access_to(:course)
      end
    end

    context 'when the user has an active subscription' do
      it 'returns true' do
        user = create(
          :user,
          :with_subscription
        )
        allow(user).to receive(:has_access_to?).
          and_return(true)

        expect(user.has_access_to?(:course)).to eq(true)
      end
    end
  end

  describe '#credit_card' do
    it 'returns nil if there is no stripe_customer_id' do
      user = create(:user, stripe_customer_id: '')

      expect(user.credit_card).to be_nil
    end

    it 'returns the active card for the stripe customer' do
      user = create(:user, stripe_customer_id: Stripe::Customer)

      expect(user.credit_card).not_to be_nil
      expect(user.credit_card['last4']).to eq '4242'
    end
  end

  describe '#has_credit_card?' do
    it 'returns false if there is no stripe_customer_id' do
      user = build(:user, stripe_customer_id: '')

      expect(user.has_credit_card?).to eq(false)
    end

    it 'returns true if there is stripe_customer_id' do
      user = build(:user, stripe_customer_id: 'cus_123')

      expect(user.has_credit_card?).to eq(true)
    end
  end

  describe '#stripe_customer?' do
    it 'returns false if there is no stripe_customer_id' do
      user = User.new(stripe_customer_id: 'cus_123')

      expect(user.stripe_customer?).to eq(true)
    end

    it 'returns true if there is stripe_customer_id' do
      user = User.new(stripe_customer_id: nil)

      expect(user.stripe_customer?).to eq(false)
    end
  end
end
