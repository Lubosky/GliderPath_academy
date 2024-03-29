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

      scope :draft, -> { where(published_at: nil) }
      scope :published, -> { where('published_at <= ?', Time.current) }
      scope :scheduled, -> { where('published_at > ?', Time.current) }
      scope :visible, -> { where.not(published_at: nil) }

      attr_accessor :status

      def draft?
        published_at.nil?
      end

      def published?
        published_at <= Time.current unless draft?
      end

      def scheduled?
        published_at > Time.current unless draft?
      end
    end

    private

    def set_status
      self.published_at =
        case status
        when DRAFT
          nil
        when PUBLISHED
          Time.current
        else
          published_at
        end
      true
    end
  end
end
