Rails.application.routes.draw do
  resources :lists, except: [:show]
  devise_for :users
  root to: 'welcome#index'
end
