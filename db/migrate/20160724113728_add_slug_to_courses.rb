class AddSlugToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :slug, :string, null: true

    courses = select_all("select id, name from courses")
    courses.each do |course|
      update(<<-SQL)
        UPDATE courses
          SET slug='#{course["name"].parameterize}'
          WHERE id=#{course["id"]}
      SQL
    end

    change_column_null :courses, :slug, false
    add_index :courses, :slug, unique: true
  end
end
