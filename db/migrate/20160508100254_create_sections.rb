class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string :title, null: false
      t.text :objective
      t.references :course, index: true, foreign_key: true

      t.timestamps
    end
  end
end
