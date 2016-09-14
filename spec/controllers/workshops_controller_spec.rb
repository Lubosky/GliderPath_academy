require 'spec_helper'

RSpec.describe WorkshopsController, type: :controller do

  before do
    stub_video
  end

  before :each do
    user.confirm
    login user
  end

  let(:user) { create(:user, :instructor, :admin) }
  let(:valid_attributes) { attributes_for(:workshop, video_attributes: attributes_for(:video)) }

  let(:invalid_attributes) {
    {
      name: '',
      short_description: '',
      notes: '',
      status: Workshop::PUBLISHED
    }
  }

  let(:updated_attributes) {
    {
      name: 'Updated Workshop #1',
      short_description: 'Updated workshop summary #1',
      notes: 'Updated workshop notes #1',
      status: Workshop::PUBLISHED
    }
  }

  describe 'GET #index' do
    before do
      get :index
    end
    it {
      is_expected.to respond_with :ok
      is_expected.to render_with_layout :application
      is_expected.to render_template :index
    }
  end

  describe 'GET #show' do

    before do
      @workshop = create(:workshop, instructor: user)
      get :show, params: { id: @workshop }
    end

    it {
      expect(assigns(:workshop)).to eq(@workshop)
      is_expected.to render_template :show
    }
  end

  describe 'GET #new' do

    before do
      get :new
    end

    it {
      expect(assigns(:workshop)).to be_a_new(Workshop)
      is_expected.to render_template :new
    }
  end

  describe 'GET #create' do

    context 'when new workshop is invalid' do
      it 'renders the page with error' do
        post :create, params: {
          workshop: invalid_attributes
        }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to match(/^Ooops! We are having trouble creating this workshop. Please check your form./)

      end
    end

    context 'when new workshop is valid' do
      it 'creates the workshop and redirects to workshops index page' do
        expect {
          post :create, params: { workshop: valid_attributes }
        }.to change(Workshop, :count).by(1)
        expect(response).to redirect_to Workshop.last
        expect(flash[:success]).to match(/^Workshop has been successfuly created./)

      end
    end
  end

  describe 'GET #update' do

    before :each do
      @workshop = create(:workshop, instructor: user)
    end

    context 'when updated workshop is invalid' do
      it 'renders the page with error' do
        put :update, params: {
          id: @workshop, workshop: invalid_attributes
        }
        @workshop.reload
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to match(/^Sorry! We are having trouble updating this workshop./)

      end
    end

    context 'when updated workshop is valid' do
      it 'updates the workshop' do
        put :update, params: {
          id: @workshop, workshop: updated_attributes
        }
        @workshop.reload
        expect(@workshop.name).to eq('Updated Workshop #1')
        expect(flash[:success]).to match(/^Workshop has been successfuly updated./)
      end
    end
  end

  describe 'GET #destroy' do

    before do
      @workshop = create(:workshop, instructor: user)
    end

    it 'deletes the workshop and redirects to workshops index page' do
      expect {
        delete :destroy, params: { id: @workshop }
      }.to change(Workshop,:count).by(-1)
      expect(response).to redirect_to root_path

    end
  end

end
