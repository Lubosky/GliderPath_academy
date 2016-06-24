Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }, path: 'account', path_names: { sign_in: 'signin', sign_out: 'signout', password: 'password', sign_up: 'signup', edit: 'password/change' }

  resource :account, only: [:show, :edit], path: 'account' do
    patch 'update_account', to: 'accounts#update_account'
    resources :charges, only: [:index, :show]
  end

  root 'courses#index'

  concern :downloadable do
    get 'download', on: :member
  end

  resources :courses do
    resources :lessons, only: [:show] do
      post :complete, on: :member
    end
    resource :purchase, only: [:create]
    get 'purchase', to: 'purchases#new'
    resource :enrollment, only: [:create], path: 'enroll'
  end

  post '/braintree/webhooks', to: 'subscriptions#webhook'

  resource :subscription, only: [:new, :create], path: 'subscribe'
  delete 'unsubscribe', to: 'subscriptions#destroy', as: 'cancel_subscription'

  resources :uploads, only: [:download], concerns: :downloadable

end
