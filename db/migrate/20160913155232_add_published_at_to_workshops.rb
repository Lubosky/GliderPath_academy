class AddPublishedAtToWorkshops < ActiveRecord::Migration[5.0]
  def change
    add_column :workshops, :published_at, :datetime

    add_index :workshops, :published_at
  end
end
