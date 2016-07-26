Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }, path: 'account', path_names: { sign_in: 'signin', sign_out: 'signout', password: 'password', sign_up: 'signup', edit: 'password/change' }

  authenticated :user do
    root 'dashboards#show', as: :authenticated_root
  end

  root 'pages#home'

  # BRAINTREE
  post '/braintree/webhooks', to: 'subscriptions#webhook'

  # ACCOUNT
  resource :account, only: [:show, :edit], path: 'account' do
    patch 'update_account', to: 'accounts#update_account'
    resources :charges, only: [:index, :show]
    resource :payment_method, only: [:create]
  end

  # COURSES
  resources :courses do
    put :sort, on: :member, as: :sortable
    resource :enrollment, only: [:create], path: 'enroll'
    resources :lessons, only: [:show] do
      post :complete, on: :member
    end
    get 'progress', on: :member
    get 'purchase', to: 'purchases#new'
    resource :purchase, only: [:create]
  end

  # DOWNLOADS
  concern :downloadable do
    get 'download', on: :member
  end

  # PAGES
  get '/contact' => 'pages#contact'
  post '/contact' => 'pages#submit_contact_form'
  get '/faq' => 'pages#faq'
  get '/privacy' => 'pages#privacy'
  get '/terms' => 'pages#terms'

  # SUBSCRIPTION
  resource :subscription, only: [:new, :create], path: 'subscribe'
  delete 'unsubscribe', to: 'subscriptions#destroy', as: 'cancel_subscription'

  # UPLOADS
  resources :uploads, only: [:download], concerns: :downloadable

end
