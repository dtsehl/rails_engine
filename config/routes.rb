Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, only: %i[show index create destroy update]
      resources :merchants, only: %i[show index create destroy update]

      namespace :items do
        get '/:id/merchant', to: 'merchants#show'
      end

      namespace :merchants do
        get '/:id/items', to: 'items#index'
      end
    end
  end
end
