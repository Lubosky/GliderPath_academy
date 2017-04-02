require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('/tmp/uploads/cache'),
  store: Shrine::Storage::FileSystem.new('/tmp/uploads/store')
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :direct_upload
