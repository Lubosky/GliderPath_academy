module Concerns
  module Publishable
    extend ActiveSupport::Concern

    included do
      DRAFT = 'Draft' unless const_defined?(:DRAFT)
      PUBLISHED = 'Published' unless const_defined?(:PUBLISHED)
      SCHEDULED = 'Scheduled' unless const_defined?(:SCHEDULED)

      STATUSES = [DRAFT, PUBLISHED, SCHEDULED] unless const_defined?(:STATUSES)

      validates :status, inclusion: { in: STATUSES }
      before_validation :set_status

      attr_accessor :status

      def self.published
        where('published_at <= ?', Time.zone.now)
      end

      def draft?
        published_at.nil?
      end

      def published?
        published_at <= Time.zone.now unless draft?
      end

      def scheduled?
        published_at > Time.zone.now unless draft?
      end
    end

    private

    def set_status
      self.published_at =
        case status
        when DRAFT
          nil
        when PUBLISHED
          Time.zone.now
        else
          published_at
        end
      true
    end
  end
end
