Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/:id/merchant', to: 'merchants#show'
        get '/find', to: 'find#show'
        get '/find_all', to: 'find#index'
      end
      resources :items, only: %i[show index create destroy update]

      namespace :merchants do
        get '/:id/items', to: 'items#index'
        get '/find', to: 'find#show'
        get '/find_all', to: 'find#index'
        get '/most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
      end
      resources :merchants, only: %i[show index create destroy update]
    end
  end
end
