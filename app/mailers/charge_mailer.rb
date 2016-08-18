class ChargeMailer < BaseMailer
  def receipt(user_id, charge_id)
    @charge = Charge.find_by_id(charge_id)
    @user = User.find_by_id(user_id)

    filename = "receipt-#{@charge.receipt_number}.pdf"
    attachments[filename] = @charge.receipt.render

    mail(
      to: @user.email,
      subject: "[#{Settings.application.name}] Payment Receipt - #{@charge.product}"
    )
  end
end
