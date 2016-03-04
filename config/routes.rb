Rails.application.routes.draw do
  resources :orders
  resources :menu_items
  resources :restaurants
  resources :admins, type: "User", only: []
  resources :users, only: [:create] do
    post 'login', on: :collection
  end
  resources :customers
  resources :managers
  resources :employees
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
