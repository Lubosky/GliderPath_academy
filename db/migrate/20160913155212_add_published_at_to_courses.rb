class AddPublishedAtToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :published_at, :datetime

    add_index :courses, :published_at
  end
end
