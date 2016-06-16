class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :braintree_plan_id, null: false

      t.timestamps
    end
  end
end
