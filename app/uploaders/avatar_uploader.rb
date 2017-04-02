require 'image_processing/mini_magick'

class AvatarUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :delete_raw
  plugin :determine_mime_type
  plugin :download_endpoint, storages: [:store], prefix: 'avatars'
  plugin :pretty_location
  plugin :processing
  plugin :remove_attachment
  plugin :validation_helpers, default_messages: {
    max_size: ->(max) { I18n.t('errors.avatar.max_size', max: max) },
    mime_type_inclusion: ->(whitelist) { I18n.t('errors.avatar.mime_type_inclusion', whitelist: whitelist) }
  }
  plugin :versions

  Attacher.validate do
    validate_max_size 1.megabytes
    validate_mime_type_inclusion ['image/jpeg', 'image/png', 'image/gif']
  end

  process(:store) do |io|
    small = resize_to_limit!(io.download, 60, 60)
    medium = resize_to_limit!(io.download, 128, 128)
    large = resize_to_limit!(io.download, 640, 640)
    {
      original: io,
      small: small,
      medium: medium,
      large: large
    }
  end
end
