class CreateLessonUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :lesson_uploads do |t|
      t.belongs_to :lesson
      t.belongs_to :upload

      t.timestamps
    end
  end
end
