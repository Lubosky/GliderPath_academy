class Workshop < ApplicationRecord
  include Concerns::Purchasable
  include Concerns::Sluggable
  include Concerns::Uploadable
  include Concerns::Videoable

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
    self.video.video_duration
  end

  def has_attachments?
    self.uploads.any?
  end

  def is_free?
    self.price == 0
  end

  def watchable_for(user)
    user.has_access_to?(self) || is_free?
  end

  private

    def slug_source
      self.name
    end

end
