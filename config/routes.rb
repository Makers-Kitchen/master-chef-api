Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :maps do
        collection do
          post 'pin'
          post 'search'
          get 'list_all'
          get 'find'
        end
      end
    end
  end
end