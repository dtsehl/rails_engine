Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      namespace :items do
        get '/:id/merchant', to: 'merchants#show'
        get '/find', to: 'find#show'
      end
      resources :items, only: %i[show index create destroy update]

      namespace :merchants do
        get '/:id/items', to: 'items#index'
        get '/find', to: 'find#show'
      end
      resources :merchants, only: %i[show index create destroy update]
    end
  end
end
