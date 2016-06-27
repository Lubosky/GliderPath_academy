require 'spec_helper'

RSpec.describe ChargesController, type: :controller do

  let(:user) { create(:user) }
  let(:charge) { create(:charge, :credit_card, user: user) }

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

  describe 'GET #show' do
    before do
      login user
      get :show, params: { id: charge, user: user }, format: :pdf
    end
    it {
      expect(assigns(:charge)).to eq(charge)
      is_expected.to respond_with :ok
    }
  end

  describe Receipt do
    it 'allows you to create a new receipt' do
      expect(Receipt.new(
        id: charge.receipt_number,
        product: charge.product,
        company: {
          name: Settings.company.name,
          address: Settings.company.address,
          email: Settings.company.email,
          logo: Rails.root.join('app/assets/images/logo-default.png')
        },
        receipt_items: [
          ['Item', charge.product],
        ],
      ).class.name).to eq('Receipt')
    end
  end

end
