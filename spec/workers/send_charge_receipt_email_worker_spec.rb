require 'spec_helper'

describe SendChargeReceiptEmailWorker, sidekiq: :inline do

  before { allow(SendChargeReceiptEmailWorker).to receive(:perform_in) }

  let(:user) { build_stubbed :user }
  let(:charge) { build_stubbed :charge }

  context '#send_charge_receipt_email', sidekiq: :inline do
    it 'schedules charge receipt email to be sent' do
      mail = double(deliver_now: true)
      expect(ChargeMailer).to receive(:receipt).with(user.id, charge.id) { mail }
      SendChargeReceiptEmailWorker.perform_async(user.id, charge.id)
    end
  end
end
