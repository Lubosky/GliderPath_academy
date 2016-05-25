class CreateUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :uploads do |t|
      t.string :file_id, null: false
      t.string :file_filename, null: false
      t.integer :file_size, null: false
      t.string :file_content_type, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
