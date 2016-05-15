Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root 'courses#index'

  resources :courses do
    resources :lessons, only: [:show]
  end
end
