class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :braintree_subscription_id
      t.integer :plan_id, null: false
      t.integer :subscriber_id, null: false
      t.string :status

      t.timestamps
    end

    add_foreign_key :subscriptions, :users, column: :subscriber_id
    add_index :subscriptions, [ :subscriber_id, :plan_id ]
  end
end
