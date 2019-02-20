Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
        post '/search', to: 'stocks#search_stock'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #login and register routes
  post 'auth/login', to: 'users#login'
  post 'auth/register', to: 'users#register'

  #add balance to user route
  post 'add_balance', to: 'users#add_balance'

  #stock action routes
  post 'buy_stock', to: 'purchased_stocks#buy_stock'
  post 'sell_stock', to: 'sold_stocks#sell_stock'
  post 'add_watchlist', to: 'watchlists#add_watchlist'
  post 'remove_watchlist', to: 'watchlists#remove_watchlist'

  #delete routes
  delete 'sold_stocks/:id', to: 'sold_stocks#destroy'
  delete 'purchased_stocks/:id', to: 'purchased_stocks#destroy'

  #cancel transation routes
  post 'cancel_sale/:id', to: 'sold_stocks#cancel_sale'
  post 'cancel_purchase/:id', to: 'purchased_stocks#cancel_purchase'

  #authorize and update routes
  get 'authorize_token', to: 'users#authorize_token'
  get 'update_user_stocks/:id', to: 'users#update_user_stocks'

  #action Cable
  mount ActionCable.server => '/cable'

end
