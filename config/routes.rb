Rails.application.routes.draw do
  devise_for :users

  root 'courses#index'

  resources :courses do
    resources :lessons, only: [:show]
  end
end
