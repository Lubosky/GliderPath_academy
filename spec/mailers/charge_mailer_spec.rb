require 'spec_helper'

describe ChargeMailer do
  let(:user) { create :user }

  describe "#receipt" do
    let(:charge) { create :charge, user: user }
    subject { ChargeMailer.receipt(user.id, charge.id) }

    it 'sends the expected email' do
      expect(subject.subject).to eq '[GliderPath Academy] Payment Receipt - GliderPath Academy - Monthly'
      expect(subject.to).to match_array [user.email]

      expect(subject.body.encoded).to include('This is a receipt for your latest GliderPath Academy payment.')
    end

    it 'contains the receipt as an attachment' do
      expect(subject.attachments.last.filename).to eq "receipt-#{charge.receipt_number}.pdf"
    end
  end

end
