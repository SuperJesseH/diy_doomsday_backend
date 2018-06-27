Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'user_dataset/index'
      get 'user_dataset/show'
      get 'user_dataset/create'
    end
  end
  namespace :api do
    namespace :v1 do
      get 'dataset/index'
      get 'dataset/show'
      get 'dataset/create'
    end
  end
  namespace :api do
    namespace :v1 do
      get 'user/index'
      get 'user/show'
      get 'user/create'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
