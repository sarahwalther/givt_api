Rails.application.routes.draw do
  resources :orders
  resources :menu_items
  resources :restaurants
  resources :users do
    post 'login', on: :collection
  end
  resources :customers
  resources :managers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
