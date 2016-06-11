class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :video_url
      t.string :video_id
      t.string :video_embed_url
      t.string :video_provider
      t.integer :video_duration
      t.references :videoable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
