Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

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

  resource :subscription, only: [:new, :create], path: 'subscribe'
  delete 'unsubscribe', to: 'subscriptions#destroy', as: 'cancel_subscription'

  resources :uploads, only: [:download], concerns: :downloadable

end
