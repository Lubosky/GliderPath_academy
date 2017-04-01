class SynchronizeRefileWithShrine < ActiveRecord::Migration[5.1]
  def change
    add_column :uploads, :file_data, :jsonb
    add_column :users, :avatar_data, :jsonb
  end
end
