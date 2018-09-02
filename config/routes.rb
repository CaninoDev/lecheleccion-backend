Rails.application.routes.draw do
  namespace :api do
    resources :articles do
      collection do
        post 'search'
      end
    end
    resources :users do
      collection do
        post 'usersList'
      end
    end
    resources :votes
  end
end
