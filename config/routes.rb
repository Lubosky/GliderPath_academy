Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }, path: 'account', path_names: { sign_in: 'signin', sign_out: 'signout', password: 'password', sign_up: 'signup', edit: 'password/change' }

  authenticated :user do
    root 'student/dashboards#show', as: :authenticated_root
  end

  root 'pages#home'

  # STRIPE
  mount StripeEvent::Engine, at: '/stripe/webhook'

  # ACCOUNT
  resource :account, only: [:show, :edit], path: 'account' do
    patch 'update_account', to: 'accounts#update_account'
    resources :charges, only: [:index, :show]
    resource :credit_card, only: [:update]
  end

  # COUPONS
  resources :coupons, only: [:show], path: 'coupon'

  # COURSES
  resources :courses do
    put :sort, on: :member, as: :sortable
    resource :enrollment, only: [:create], path: 'enroll'
    resources :lessons, only: [:show] do
      post :complete, on: :member
      get :preview, on: :member
    end
    get 'progress', on: :member
    get 'purchase', to: 'purchases#new'
    resource :purchase, only: [:create]
  end

  # DISCOURSE
  resource :forum_sessions, only: :new
  get '/forum', to: redirect("#{Forum.url('session/sso')}")

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
  resource :reactivation, only: [:create]
  resource :subscription, only: [:new, :create], path: 'subscribe'
  delete 'unsubscribe', to: 'subscriptions#destroy', as: 'cancel_subscription'

  # UPLOADS
  resources :uploads, only: [:download], concerns: :downloadable

  # WORKSHOPS
  resources :workshops do
    get 'purchase', to: 'purchases#new'
    resource :purchase, only: [:create]
  end
end
