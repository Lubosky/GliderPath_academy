module Concerns
  module Videoable
    extend ActiveSupport::Concern

    included do
      has_one :video, dependent: :destroy, as: :videoable
    end

  end
end
