class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :title, null: false
      t.text :notes
      t.references :section, index: true, foreign_key: true

      t.timestamps
    end
  end
end
