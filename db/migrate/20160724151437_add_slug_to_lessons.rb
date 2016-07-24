class AddSlugToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :slug, :string, null: true

    lessons = select_all("select id, title from lessons")
    lessons.each do |lesson|
      update(<<-SQL)
        UPDATE lessons
          SET slug='#{lesson["title"].parameterize}'
          WHERE id=#{lesson["id"]}
      SQL
    end

    change_column_null :lessons, :slug, false
    add_index :lessons, :slug, unique: true
  end
end
