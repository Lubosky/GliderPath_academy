require 'spec_helper'

RSpec.describe CouponPolicy do
  permissions :show? do
    it 'grants access' do
      coupon = create(:coupon)

      subject = described_class

      expect(subject).to permit(coupon)
    end
  end
end
