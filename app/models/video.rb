class Video < ApplicationRecord
  belongs_to :videoable, polymorphic: true

  validates :video_url, format: { with: /\A(https?:\/\/)?(www\.)?((vimeo\.com\/\d+\/?)|((.+)?(wistia.com|wi.st)\/(medias|embed)\/.*\/?)|(youtube\.com\/watch\?v=[-a-zA-Z0-9.%_]+)|(youtu\.be\/[-a-zA-Z0-9.%_]+))\z/i }

  before_save :parse_video_info, if: proc { video_url_changed? }

  private

    def parse_video_info
      video = VideoInfo.new(video_url)

      self.video_provider = video.provider
      self.video_id = video.video_id
      self.video_embed_url = video.embed_url
      self.video_duration = video.duration
      self.videoable = videoable
    end
end
