class AddBraintreeDataToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :braintree_payment_method, :string
    add_column :users, :paypal_email, :string
    add_column :users, :card_type, :string
    add_column :users, :card_exp_month, :integer
    add_column :users, :card_exp_year, :integer
    add_column :users, :card_last4, :string
  end
end
