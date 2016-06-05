class RenameUserIdToInstructorId < ActiveRecord::Migration[5.0]
  def change
    rename_column :courses, :user_id, :instructor_id
  end
end
