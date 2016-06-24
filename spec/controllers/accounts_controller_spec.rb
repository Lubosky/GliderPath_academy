require 'spec_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }

  before do
    login user
  end

  describe 'GET #show' do
    it 'renders #show template for logged in user' do
      get :show

      is_expected.to respond_with :ok
      is_expected.to render_template :show
    end
  end

  describe 'GET #edit' do
    it 'renders #edit template' do
      get :edit

      is_expected.to respond_with :ok
      is_expected.to render_template :edit
    end
  end

  describe 'GET #update' do

    context 'when updated account is invalid' do
      it 'renders the page with error' do
        patch :update_account, params: { user: { first_name: '', last_name: '' } }

        expect(response).to render_template(:edit)
        expect(flash[:alert]).to match(/^Sorry! We are having trouble updating your account./)
      end
    end

    context 'when updated account is valid' do
      it 'updates the account' do
        patch :update_account, params: { user: { first_name: 'Frank', last_name: 'Cotton' } }

        expect(user.first_name).to eq('Frank')
        expect(flash[:success]).to match(/^Your account has been successfully updated!/)
      end
    end
  end
end
