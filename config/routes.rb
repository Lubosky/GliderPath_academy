Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root 'courses#index'

  concern :downloadable do
    get 'download', on: :member
  end

  resources :courses do
    resources :lessons, only: [:show]
  end

  resources :uploads, only: [:download], concerns: :downloadable

end
