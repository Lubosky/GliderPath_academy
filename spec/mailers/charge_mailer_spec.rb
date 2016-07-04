require 'spec_helper'

describe ChargeMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe "#receipt" do
    let(:user) { create :user }
    let(:charge) { create :charge, user: user }
    subject { ChargeMailer.receipt(user.id, charge.id) }

    it 'sends the expected email' do
      expect(subject).to have_subject '[GliderPath Academy] Payment Receipt - GliderPath Academy - Monthly'
      expect(subject).to deliver_to user.email
      expect(subject).to have_body_text(/This is a receipt for your latest GliderPath Academy payment./)
    end

    it 'contains the receipt as an attachment' do
      expect(subject.attachments.last.filename).to eq "receipt-#{charge.receipt_number}.pdf"
    end
  end

end
