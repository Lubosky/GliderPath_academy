require 'spec_helper'

RSpec.describe DashboardsController, type: :controller do

  let(:user) { build_stubbed(:user) }

  describe 'GET #show' do

    before do
      user.confirm
      login user
      get :show
    end

    it {
      is_expected.to respond_with :ok
      is_expected.to render_with_layout :application
      is_expected.to render_template :show
    }

  end

end
