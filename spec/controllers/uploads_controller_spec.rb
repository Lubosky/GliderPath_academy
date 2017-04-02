require 'spec_helper'

RSpec.describe UploadsController, type: :controller do
  include Downloadable

  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:section) { create(:section, course: course) }
  let(:lesson) { create(:lesson, section: section, position: 1) }

  describe 'GET #download' do

    before do
      user.confirm
      login user
      file = File.open('spec/support/images/yoda.jpg')
      RequestStore.store[:current_user] = user
      @upload = create(:upload, file: file, uploader: user, uploadable: lesson)
    end

    it {
      # expect(controller).to receive(:send_file).with(@upload.file.download, filename: 'yoda.jpg', type: 'image/jepg', disposition: :attachment){controller.render nothing: true}
      get :download, params: { id: @upload.id.to_s }
      expect(response.status).to eq(200)
      expect(response.header['Content-Type']).to match('image/jpeg')
      expect(@upload.extension).to eq('jpg')
    }
  end

  describe 'includes Downloadable concern' do
    it { expect(UploadsController.ancestors.include? Downloadable).to eq(true) }
  end

end
