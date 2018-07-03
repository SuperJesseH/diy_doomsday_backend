Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :users, only: [:index, :show, :create]

      resources :datasets, only: [:index, :show, :create]

      resources :user_datasets, only: [:index, :show, :create]

      resources :sessions, only: [:create]

      resources :data_requests, only: [:index, :show, :create]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
