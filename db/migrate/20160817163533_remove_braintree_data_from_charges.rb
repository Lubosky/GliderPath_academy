class RemoveBraintreeDataFromCharges < ActiveRecord::Migration[5.0]
  def change
    remove_column :charges, :braintree_payment_method, :string
    remove_column :charges, :paypal_email, :string
  end
end
