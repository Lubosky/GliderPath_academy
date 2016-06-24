require 'spec_helper'

RSpec.describe ChargesController, type: :controller do

  let(:user) { build_stubbed(:user) }

  describe 'GET #index' do
    before do
      login user
      get :index
    end
    it {
      is_expected.to respond_with :ok
      is_expected.to render_template :index
    }
  end
end
