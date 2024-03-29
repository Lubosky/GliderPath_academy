require 'spec_helper'

describe Coupon, type: :model do
  it 'has a code of the given stripe coupon code' do
    coupon = Coupon.new('50OFF')
    expect(coupon.code).to eq '50OFF'
  end

  it 'uses the corresponding stripe coupon' do
    coupon = create(
      :coupon,
      code: '25OFF',
      amount_off: 2500,
      duration: 'once'
    )

    expect(coupon.stripe_coupon.id).to eq coupon.code
  end

  it 'delegates duration to stripe_coupon' do
    coupon = double(Stripe::Coupon, duration: 'once')
    allow(Stripe::Coupon).to receive(:retrieve).and_return(coupon)

    expect(coupon.duration).to eq 'once'
  end

  it 'delegates duration_in_months to stripe_coupon' do
    coupon = double(Stripe::Coupon, duration_in_months: '6')
    allow(Stripe::Coupon).to receive(:retrieve).and_return(coupon)

    expect(coupon.duration_in_months).to eq '6'
  end

  describe '#valid?' do
    it 'is valid if the coupon exists and is usable' do
      coupon = create(:coupon)

      expect(coupon).to be_valid
    end

    it 'is not valid if the coupon code does not exist' do
      exception = Stripe::InvalidRequestError.new('No such coupon', 'NONE')
      allow(Stripe::Coupon).to receive(:retrieve).and_raise(exception)
      coupon = Coupon.new('NONE')

      expect(coupon).not_to be_valid
    end

    it "is not valid if it can't be used" do
      coupon = create(:coupon)
      stripe_coupon = double(Stripe::Coupon, valid: false)
      allow(Stripe::Coupon).to receive(:retrieve).and_return(stripe_coupon)

      expect(coupon).not_to be_valid
    end
  end

  describe '#apply' do
    context 'when it is an amount off discount' do
      it 'deducts that dollar amount' do
        coupon = create(:coupon)
        stripe_coupon = double(Stripe::Coupon, amount_off: 2500, percent_off: nil)
        allow(Stripe::Coupon).to receive(:retrieve).and_return(stripe_coupon)

        amount = coupon.apply(99)

        expect(amount).to eq 74
      end
    end

    context 'when it is a percentage off discount' do
      it 'deducts that percentage off the amount' do
        coupon = create(:coupon)
        stripe_coupon = double(Stripe::Coupon, amount_off: nil, percent_off: 50)
        allow(Stripe::Coupon).to receive(:retrieve).and_return(stripe_coupon)

        amount = coupon.apply(99)

        expect(amount).to eq 49.50
      end
    end
  end
end
