class SendChargeReceiptEmailWorker
  include Sidekiq::Worker

  def perform(user_id, charge_id)
    ChargeMailer.receipt(user_id, charge_id).deliver_now
  end

end

