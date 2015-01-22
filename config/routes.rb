Rails.application.routes.draw do
  resources :lists do
    resources :items, only:[:new, :create]
  end
  devise_for :users
  root to: 'welcome#index'
end
