Rails.application.routes.draw do
  namespace :api do
    resources :articles, only: %i[index] do
      collection do
        get 'bias'
        post 'search'
      end
    end
    resources :users, only: %i[index create show]
    resources :votes, only: %i[create show index]
  end
end
