Rails.application.routes.draw do
  root 'courses#index'

  resources :courses do
    resources :lessons, only: [:show]
  end
end
