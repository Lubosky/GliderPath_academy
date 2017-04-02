require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new(Rails.root.join('tmp'), prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new(Rails.root.join('tmp'), prefix: 'uploads/store')
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :direct_upload
