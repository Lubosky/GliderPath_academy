class AddBioAndHeadlineToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :headline, :string
  end
end
