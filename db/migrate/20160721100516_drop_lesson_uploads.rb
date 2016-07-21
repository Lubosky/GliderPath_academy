class DropLessonUploads < ActiveRecord::Migration[5.0]
  def up
    drop_table :lesson_uploads
  end

  def down
    create_table :lesson_uploads do |t|
      t.belongs_to :lesson
      t.belongs_to :upload

      t.timestamps
    end
  end
end
