class CreateEnrollments < ActiveRecord::Migration[5.0]
  def change
    create_table :enrollments do |t|
      t.integer :course_id
      t.integer :student_id
      t.string :status

      t.timestamps
    end

    add_foreign_key :enrollments, :users, column: :student_id
    add_index(:enrollments, [ :student_id, :course_id ])
  end
end
