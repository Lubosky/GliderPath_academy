require 'spec_helper'

describe Video, type: :model do
  let(:video_vimeo) { Video.create(video_url: 'https://vimeo.com/132090907/') }
  let(:video_wistia) { Video.create(video_url: 'https://gliderpath.wistia.com/medias/b5h5j1nu4c/') }
  let(:video_youtube) { Video.create(video_url: 'https://youtu.be/3dXu5aguI80') }
  let(:video_empty) { Video.create(video_url: '') }
  let(:video_dummy) { Video.create(video_url: 'example.com') }

  it 'should require valid URL' do
    expect(Video.new(video_url: video_empty.video_url)).not_to be_valid
    expect(Video.new(video_url: video_dummy.video_url)).not_to be_valid
    expect(Video.new(video_url: video_vimeo.video_url)).to be_valid
    expect(Video.new(video_url: video_wistia.video_url)).to be_valid
    expect(Video.new(video_url: video_youtube.video_url)).to be_valid
  end

  it 'should get a valid Vimeo video info' do
    video = video_vimeo

    expect(video.video_embed_url).to be_present
    expect(video.video_duration).to be_present
    expect(video.video_provider).to be_present
    expect(video.video_id).to be_present
    expect(video.video_url).to eq video_vimeo[:video_url]
  end
end
