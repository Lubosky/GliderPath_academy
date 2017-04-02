module Concerns
  module Uploadable
    extend ActiveSupport::Concern

    included do
      include FileUploader[:file]

      has_many :uploads, dependent: :destroy, as: :uploadable
      has_many :uploaders, through: :uploads, as: :uploadable, foreign_key: :uploader_id, class_name: 'User'
    end
  end
end
