class AddCancellationDatesToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :canceled_on, :date
    add_column :subscriptions, :scheduled_for_cancellation_on, :date
  end
end
