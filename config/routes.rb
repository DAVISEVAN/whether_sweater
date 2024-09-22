Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'forecasts/show'
      get 'forecast', to: 'forecasts#show'
      resources :users, only: [:create]
      resources :sessions, only: [:create]
    end
  end
end