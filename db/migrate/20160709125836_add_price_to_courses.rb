class AddPriceToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :price, :decimal, precision: 6, scale: 2
  end
end
