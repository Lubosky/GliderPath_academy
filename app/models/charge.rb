class Charge < ApplicationRecord
  belongs_to :user, inverse_of: :uploads

  validates_presence_of :user_id
  validates :braintree_transaction_id, uniqueness: true

  after_commit :send_receipt

  def receipt_number
    "#{self.created_at.strftime('%Y-%m-%d')}-#{self.id}"
  end

  def receipt
    Receipt.new(
      id: self.receipt_number,
      product: self.product,
      company: {
        name: Settings.company.name,
        address: Settings.company.address,
        email: Settings.company.email,
        logo: Rails.root.join('app/assets/images/logo-default.png')
      },
      receipt_items: receipt_items,
      font: {
        bold: Rails.root.join('app/assets/fonts/lato-black.ttf'),
        normal: Rails.root.join('app/assets/fonts/lato-regular.ttf'),
      }
    )
  end

  def receipt_items
    items = [
      ['Date',            "<b>#{self.created_at.strftime('%b %e, %Y')}"],
      ['Account billed',  "<b>#{user.name}</b> (#{user.email})"],
      ['Item',            "<b>#{self.product}</b>"],
      ['Amount',          "<b>USD $#{self.amount}"],
      ['Charged to',      self.paypal_email.present? ? "<b>PayPal</b> (#{self.paypal_email})" : "<b>#{self.card_type}</b> xxxx-#{self.card_last4}"],
      ['Transaction ID',  "<b>#{self.braintree_transaction_id}</b>"],
    ]
  end

  def send_receipt
    SendChargeReceiptEmailWorker.perform_async(self.user_id, self.id)
  end

end
