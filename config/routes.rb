Rails.application.routes.draw do
  namespace :api do
    resources :articles, only: %i[index] do
      collection do
        post 'search'
      end
    end
    resources :users, only: %i[index create show] do
      collection do
        post 'usersList'
      end
      resources :vote, only: %i[create index]
    end
  end
end
