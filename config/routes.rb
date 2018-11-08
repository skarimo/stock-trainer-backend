Rails.application.routes.draw do
  # resources :statuses
  # resources :sold_stocks
  # resources :watchlists
  # resources :owned_stocks
  namespace :api do
    namespace :v1 do
        post '/search', to: 'stocks#search_stock'
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'users#login'
  post 'auth/register', to: 'users#register'

  post 'buy_stock', to: 'owned_stocks#buy_stock'
  post 'sell_stock', to: 'owned_stocks#sell_stock'

  get 'users/:id', to: 'users#show'
  get 'authorize_token', to: 'users#authorize_token'

  # /api/v1/stocks/search
  # post '/api/v1/stocks/search', to: 'stocks#search_stock'

end


# search_stock
