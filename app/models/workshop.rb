class Workshop < ApplicationRecord
  include Concerns::Publishable
  include Concerns::Purchasable
  include Concerns::Sluggable
  include Concerns::Uploadable
  include Concerns::Videoable

  CACHE_KEY_BASE = ['models', model_name.name.humanize.downcase].freeze

  belongs_to :instructor, inverse_of: :workshops, class_name: 'User'

  validates :name, presence: true
  validates :short_description, presence: true
  validates :notes, presence: true
  validates :video, presence: true
  validates :instructor_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999.99 }

  accepts_nested_attributes_for :uploads, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :video, reject_if: :all_blank, allow_destroy: true
  accepts_attachments_for :uploads, append: true

  def content_length
    video.video_duration
  end

  def has_attachments?
    uploads.any?
  end

  def is_free?
    price == 0
  end

  def watchable_for(user)
    user.has_access_to?(self) || is_free?
  end

  private

  def slug_source
    name
  end

  def self.content_length
    Rails.cache.fetch([CACHE_KEY_BASE, __method__, Workshop.video_cache_key]) do
      joins(:video).group('workshops.id').sum(:video_duration)
    end
  end

  def self.ordered
    order(created_at: :desc)
  end

  def self.video_cache_key
    Video.where(videoable_type: model_name.name.humanize).all.cache_key
  end
end
