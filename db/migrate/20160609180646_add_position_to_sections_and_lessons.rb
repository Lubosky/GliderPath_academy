class AddPositionToSectionsAndLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :position, :integer
    add_column :lessons, :position, :integer
  end
end
