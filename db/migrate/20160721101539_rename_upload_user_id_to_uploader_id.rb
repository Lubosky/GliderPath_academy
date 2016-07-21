class RenameUploadUserIdToUploaderId < ActiveRecord::Migration[5.0]
  def change
    rename_column :uploads, :user_id, :uploader_id

    add_foreign_key :uploads, :users, column: :uploader_id
  end
end
