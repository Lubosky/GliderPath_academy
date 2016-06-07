class CreateEnrolledLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :enrolled_lessons do |t|
      t.integer :lesson_id
      t.integer :student_id
      t.string :status

      t.timestamps
    end

    add_foreign_key :enrolled_lessons, :users, column: :student_id
  end
end
