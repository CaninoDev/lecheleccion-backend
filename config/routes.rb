Rails.application.routes.draw do
  namespace :api do
    resources :users do
      resources :articles, except: %s[show, destroy] do
        resources :votes, only: %s[update]
      end
    end
    match '/articles/fetchNews' => 'articles#fetch_news', via: [:get, :post]
  end
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
