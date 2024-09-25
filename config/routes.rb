Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecasts/show'
      get 'forecast', to: 'forecasts#show'
      get 'book-search', to: 'books_search#index'
      post 'road_trip', to: 'road_trips#create'
      resources :users, only: [:create]
      resources :sessions, only: [:create] 
    end
  end
end