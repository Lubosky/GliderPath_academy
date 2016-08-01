class CreateWorkshops < ActiveRecord::Migration[5.0]
  def change
    create_table :workshops do |t|
      t.string :name
      t.string :short_description
      t.text :notes
      t.decimal :price, precision: 6, scale: 2
      t.string :slug, null: false
      t.integer :instructor_id, index: true

      t.timestamps
    end

    add_foreign_key :workshops, :users, column: :instructor_id
    add_index :workshops, :slug, unique: true
  end
end
