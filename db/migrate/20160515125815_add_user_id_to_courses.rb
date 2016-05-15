class AddUserIdToCourses < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :user, index: true, foreign_key: true
  end
end
