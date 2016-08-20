class Charge < ApplicationRecord
  belongs_to :user, inverse_of: :charges

  validates_presence_of :user_id
  validates :stripe_charge_id, uniqueness: true

  after_commit :send_receipt

  def receipt_number
    "#{created_at.to_s(:receipt)}-#{id}"
  end

  def receipt
    Receipt.new(
      id: receipt_number,
      product: product,
      company: {
        name: Settings.company.name,
        address: Settings.company.address,
        email: Settings.company.email,
        logo: Rails.root.join('app/assets/images/logo-default.png')
      },
      receipt_items: receipt_items,
      font: {
        bold: Rails.root.join('app/assets/fonts/lato-black.ttf'),
        normal: Rails.root.join('app/assets/fonts/lato-regular.ttf')
      }
    )
  end

  def receipt_items
    items = [
      ['Date',            "<b>#{created_at.to_s(:default)}"],
      ['Account billed',  "<b>#{user.name}</b> (#{user.email})"],
      ['Item',            "<b>#{product}</b>"],
      ['Amount',          "<b>USD $#{amount}"],
      ['Charged to',      "<b>#{card_brand}</b> xxxx-#{card_last4}"],
      ['Transaction ID',  "<b>#{stripe_charge_id}</b>"]
    ]
  end

  def send_receipt
    SendChargeReceiptEmailWorker.perform_async(user_id, id)
  end
end
