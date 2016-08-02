require 'spec_helper'

describe Video, type: :model do

  before do
    stub_video
    @video = create(:video)
  end

  it 'should require valid URL' do
    expect(video_empty_url).not_to be_valid
    expect(video_dummy_url).not_to be_valid
    expect(video_vimeo_url).to be_valid
    expect(video_wistia_url).to be_valid
    expect(video_youtube_url).to be_valid
  end

  it 'should get a valid Vimeo video info' do
    expect(@video.video_embed_url).to be_present
    expect(@video.video_duration).to be_present
    expect(@video.video_provider).to be_present
    expect(@video.video_id).to be_present
    expect(@video.video_url).to eq @video[:video_url]
  end

  def video_vimeo_url
    Video.new(video_url: 'https://vimeo.com/132090907/')
  end

  def video_wistia_url
    Video.new(video_url: 'https://gliderpath.wistia.com/medias/b5h5j1nu4c/')
  end

  def video_youtube_url
    Video.new(video_url: 'https://youtu.be/MfYYyaKLgd8')
  end

  def video_dummy_url
    Video.new(video_url: 'example.com')
  end

  def video_empty_url
    Video.new(video_url: '')
  end
end
