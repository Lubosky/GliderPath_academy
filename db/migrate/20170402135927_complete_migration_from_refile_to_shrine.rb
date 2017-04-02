class CompleteMigrationFromRefileToShrine < ActiveRecord::Migration[5.1]
  def up
    change_column :uploads, :file_id, :string, null: true
    change_column :uploads, :file_filename, :string, null: true
    change_column :uploads, :file_size, :integer, null: true
    change_column :uploads, :file_content_type, :string, null: true

    execute <<-SQL
      UPDATE users
        SET avatar_id = null
    SQL

    execute <<-SQL
      UPDATE uploads
        SET file_id = null
    SQL

    change_column :uploads, :file_id, 'jsonb USING CAST(file_id AS jsonb)'
    change_column :users, :avatar_id, 'jsonb USING CAST(avatar_id AS jsonb)'

    User.update_all('avatar_id=avatar_data')

    Upload.update_all('file_id=file_data')

    remove_column :uploads, :file_data, :jsonb
    remove_column :uploads, :file_filename, :string
    remove_column :uploads, :file_size, :integer
    remove_column :uploads, :file_content_type, :string
    remove_column :users, :avatar_data, :jsonb

    change_column :uploads, :file_id, :jsonb, null: false

    rename_column :uploads, :file_id, :file_data
    rename_column :users, :avatar_id, :avatar_data
  end

  def down
  end
end
