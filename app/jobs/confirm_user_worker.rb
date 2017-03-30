class ConfirmUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find_by(id: user_id)
    unless user.confirmed?
      if user.stripe_customer_id.present?
        user.confirm
      else
        user.send_confirmation_instructions
      end
    end
  end
end
