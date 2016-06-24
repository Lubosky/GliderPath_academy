require 'spec_helper'

RSpec.describe UploadsController, type: :controller do
  include Downloadable

  let(:user) { build_stubbed(:user) }

  describe 'GET #download' do

    before do
      user.confirm
      login user
      RequestStore.store[:current_user] = user
      @upload = create(:upload, user: user)
    end

    it {
      # TODO: test file download
      # expect(controller).to receive(:send_file).with(download_upload_path(@upload), filename: 'yoda.jpg', type: 'image/jpg', disposition: 'attachment'){controller.render nothing: true}
      get :download, params: { id: @upload.id.to_s }
      expect(response.status).to eq(200)
      expect(response.header['Content-Type']).to match('image/jpg')
      expect(@upload.basename).to eq('yoda')
    }
  end

  describe 'includes Downloadable concern' do
    it { expect(UploadsController.ancestors.include? Downloadable).to eq(true) }
  end

end
