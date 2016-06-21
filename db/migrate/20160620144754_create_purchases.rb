class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.string :braintree_purchase_id
      t.integer :purchaser_id, null: false
      t.references :purchasable, polymorphic: true, null: false

      t.timestamps
    end

    add_foreign_key :purchases, :users, column: :purchaser_id
    add_index :purchases, [:purchaser_id, :purchasable_type, :purchasable_id], name: 'index_purchases_on_purchaser_id_purchasable_type_purchasable_id', unique: true
  end
end
