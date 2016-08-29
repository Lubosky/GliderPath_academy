require 'spec_helper'

describe Purchase, type: :model do
  describe 'validations' do
    subject { create :purchase, :course_purchase }

    it 'validates and associates with' do
      is_expected.to belong_to :purchasable
      is_expected.to belong_to :purchaser

      is_expected.to validate_uniqueness_of(:purchaser_id).scoped_to(:purchasable_id, :purchasable_type)
    end
  end

  context '#fulfill' do
    it 'creates a purchase with proper stripe_charge_id' do
      purchase = build(:purchase, :course_purchase, price: 49.99)
      stripe_charge_id = 'ch_17hjFm2eZvKYlo2Cf6ceKOqV'

      purchase.fulfill
      result = purchase.stripe_charge_id

      expect(result).to eq(stripe_charge_id)
    end

    it 'does not fulfill with a bad credit card' do
      stripe_charge = double('stripe_charge', create: false)
      allow(StripeCharge).to receive(:new).
        and_return(stripe_charge)
      purchase = build(:purchase)

      expect(purchase.fulfill).to be_falsey
    end
  end

  context '#coupon' do
    it 'returns a coupon from stripe_coupon_id' do
      create(:coupon, code: '5OFF')
      subscription = build(:subscription, stripe_coupon_id: '5OFF')

      expect(subscription.coupon.code).to eq '5OFF'
    end
  end

  context '#has_invalid_coupon?' do
    context 'with no coupon' do
      it 'returns false' do
        purchase = build(:purchase, stripe_coupon_id: nil)

        expect(purchase).not_to have_invalid_coupon
      end
    end

    context 'with a valid coupon' do
      it 'returns false' do
        purchase = build(
          :purchase,
          stripe_coupon_id: coupon_code(valid?: true)
        )

        expect(purchase).not_to have_invalid_coupon
      end
    end

    context 'with an invalid coupon' do
      it 'returns true' do
        purchase = build(
          :purchase,
          stripe_coupon_id: coupon_code(valid?: false)
        )

        expect(purchase).to have_invalid_coupon
      end
    end

    def coupon_code(*attributes)
      generate(:code).tap do |code|
        coupon = double(Coupon, *attributes)
        allow(Coupon).to receive(:new).with(code).and_return(coupon)
      end
    end
  end
end
