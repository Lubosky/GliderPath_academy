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
    resource :enrollment, only: [:create], path: 'enroll'
  end

  resources :uploads, only: [:download], concerns: :downloadable

end
