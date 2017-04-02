class FileUploader < Shrine
  plugin :delete_raw
  plugin :determine_mime_type
  plugin :download_endpoint, storages: [:store], prefix: 'attachments'
  plugin :pretty_location
  plugin :remove_attachment
  plugin :validation_helpers, default_messages: {
    max_size: ->(max) { I18n.t('errors.file.max_size', max: max) },
    extension_inclusion: ->(list) { I18n.t('errors.file.extension_inclusion', list: list) }
  }

  Attacher.validate do
    validate_max_size 10.megabytes
    validate_extension_inclusion %w(doc docx ppt pptx xls xlsx pdf zip jpg jpeg png gif)
  end
end
