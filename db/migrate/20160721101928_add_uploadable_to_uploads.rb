class AddUploadableToUploads < ActiveRecord::Migration[5.0]
  def change
    add_reference :uploads, :uploadable, polymorphic: true, null: false, index: true
  end
end
