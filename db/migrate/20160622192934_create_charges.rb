class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.belongs_to :user
      t.string :product
      t.decimal :amount
      t.string :braintree_transaction_id
      t.string :braintree_payment_method
      t.string :paypal_email
      t.string :card_type
      t.integer :card_exp_month
      t.integer :card_exp_year
      t.string :card_last4

      t.timestamps
    end

    add_index :charges, :braintree_transaction_id, unique: true
  end
end
