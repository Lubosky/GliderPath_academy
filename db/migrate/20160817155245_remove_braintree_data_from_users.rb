class RemoveBraintreeDataFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :braintree_payment_method, :string
    remove_column :users, :paypal_email, :string
    remove_column :users, :card_type, :string
    remove_column :users, :card_exp_month, :integer
    remove_column :users, :card_exp_year, :integer
    remove_column :users, :card_last4, :string
  end
end
