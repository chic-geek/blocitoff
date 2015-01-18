Rails.application.routes.draw do
  get 'items/new'

  resources :lists
    resources :items, only:[:create]
  devise_for :users
  root to: 'welcome#index'
end
