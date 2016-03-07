Rails.application.routes.draw do
  resources :users, only: :create do
    post 'login', on: :collection
  end

  resources :managers, except: [:create, :index] do
    resources :restaurants
  end

  resources :customers, except: [:create, :index] do
    resources :orders, except: [:destroy, :update]
  end

  resources :restaurants, only: [:index, :show] do
    resources :employees, except: :create
    resources :orders, only: [:index, :show]
    resources :menu_items
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
