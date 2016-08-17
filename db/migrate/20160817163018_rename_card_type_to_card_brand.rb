class RenameCardTypeToCardBrand < ActiveRecord::Migration[5.0]
  def change
    rename_column :charges, :card_type, :card_brand
  end
end
