require 'spec_helper'

RSpec.describe ReactivationsController, type: :controller do
  context '#create' do
    it 'calls #fulfill on a "Reactivation" and it works' do
      user = create_user_stubbing_subscription(double)
      reactivating_subscription(works: true, subscription: user.subscription)
      login user

      post :create

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq t('flash.subscriptions.reactivate.success')
    end

    it 'calls #fulfill on a "Reactivation" and it does not work' do
      user = create_user_stubbing_subscription(double)
      reactivating_subscription(works: false, subscription: user.subscription)
      login user

      post :create

      expect(flash[:error]).to eq t('flash.subscriptions.reactivate.error')
      expect(response).to redirect_to(root_path)
    end
  end

  def create_user_stubbing_subscription(subscription)
    user = create(:user)
    allow(user).to receive(:subscription).and_return(subscription)
    user
  end

  def reactivating_subscription(works:, subscription:)
    allow(Reactivation).
      to receive(:new).
      with(subscription: subscription).
      and_return(double('Reactivation', fulfill: works))
  end
end
