class RenameBraintreeToStripe < ActiveRecord::Migration[5.0]
  def change
    rename_column :charges, :braintree_transaction_id, :stripe_charge_id
    rename_column :plans, :braintree_plan_id, :stripe_plan_id
    rename_column :purchases, :braintree_purchase_id, :stripe_charge_id
    rename_column :subscriptions, :braintree_subscription_id, :stripe_subscription_id
    rename_column :users, :braintree_customer_id, :stripe_customer_id
  end
end
