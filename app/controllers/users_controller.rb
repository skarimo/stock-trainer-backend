class UsersController < ApplicationController
skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate(params["username"], params["password"])
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def add_balance
    @user = User.find(params[:user_id])
    @new_account_balance = @user.account_balance.to_f + params[:deposit_amount].to_f
    @user.update(account_balance: @new_account_balance)
    render json: {"account_balance": @user.account_balance}
  end

  def register
    @user = User.create(user_params)
   if @user.save
    @user.owned_stock_shares.create(stock_id: 331, owned_shares: 10)
    @user.owned_stock_shares.create(stock_id: 7892, owned_shares: 10)
    @user.owned_stock_shares.create(stock_id: 5514, owned_shares: 10)
    @user.watchlists.create(stock_id: 381)
    @user.watchlists.create(stock_id: 3439)
    @user.watchlists.create(stock_id: 3438)
    response = { message: 'User created successfully'}
    render json: response, status: :created
   else
    render json: @user.errors, status: :bad
   end
  end

  def update_user_stocks
    @user = User.find(params[:id])
    # @purchased_stocks = @user.purchased_stocks
    # @sold_stocks = @user.sold_stocks
    render json: {
      account_balance: @user.account_balance,
      purchased_stocks:  @user.purchased_stocks.map{|purchased_stocks| {
        id: purchased_stocks.id,
        owned_shares: purchased_stocks.owned_shares,
        pending_buy_shares: purchased_stocks.pending_buy_shares,
        buy_price: purchased_stocks.buy_price,
        status: purchased_stocks.status,
        stock: purchased_stocks.stock
      }},
      sold_stocks:  @user.sold_stocks.map{|sold_stock| {
        id: sold_stock.id,
        sold_shares: sold_stock.sold_shares,
        pending_sale_shares: sold_stock.pending_sale_shares,
        sale_price: sold_stock.sale_price,
        status: sold_stock.status,
        stock: sold_stock.stock
      }},
      watchlists:  @user.watchlists.map{|watchlist| {
        id: watchlist.id,
        stock: watchlist.stock,
        liveStockData: {quote: watchlist.stock.getLiveData}
      }}
    }
  end

  def update_owned
    @user = User.find(params[:id])
    @owned_stock_shares = @user.owned_stock_shares.map{|owned_stock| {
      id: owned_stock.id,
      owned_shares: owned_stock.owned_shares,
      avg_buy_price: owned_stock.avg_buy_price,
      stock: owned_stock.stock,
      # liveStockData: {quote: owned_stock.stock.getLiveData}
    }}
    render json: @owned_stock_shares
  end

  def authorize_token
    @user_id = JsonWebToken.decode(request.headers["Authorization"])["user_id"]
    @user = User.find(@user_id)
    render json: @user
  end


private

# user: {account_balance: @user.account_balance, email: @user.email, first_name: @user.first_name, id: @user.id, last_name: @user.last_name, purchased_stocks: @user.purchased_stocks, username: @user.username, watchlists: @user.watchlists}


  def authenticate(username, password)
    command = AuthenticateUser.call(username, password)
    if command.success?
      @user = User.find(JsonWebToken.decode(command.result)["user_id"])
      render json: {
        access_token: command.result,
        user: {account_balance: @user.account_balance, email: @user.email, first_name: @user.first_name, id: @user.id,  username: @user.username, last_name: @user.last_name,
          watchlists: @user.watchlists.map{|stock| {id: stock.id, stock: stock}
        },
        purchased_stocks:  @user.purchased_stocks.map{|purchased_stocks| {
          id: purchased_stocks.id,
          owned_shares: purchased_stocks.owned_shares,
          pending_buy_shares: purchased_stocks.pending_buy_shares,
          buy_price: purchased_stocks.buy_price,
          status: purchased_stocks.status,
          stock: purchased_stocks.stock
        }},
        sold_stocks:  @user.sold_stocks.map{|sold_stock| {
          id: sold_stock.id,
          sold_shares: sold_stock.sold_shares,
          pending_sale_shares: sold_stock.pending_sale_shares,
          sale_price: sold_stock.sale_price,
          status: sold_stock.status,
          stock: sold_stock.stock
        }},
        owned_stock_shares:  @user.owned_stock_shares.map{|owned_stock| {
          id: owned_stock.id,
          owned_shares: owned_stock.owned_shares,
          avg_buy_price: owned_stock.avg_buy_price,
          stock: owned_stock.stock,
          liveStockData: {quote: owned_stock.stock.getLiveData}
        }},
        watchlists:  @user.watchlists.map{|watchlist| {
          id: watchlist.id,
          stock: watchlist.stock,
          liveStockData: {quote: watchlist.stock.getLiveData}
        }}
      }
    }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
   end

  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name, :category_id, :account_balance)
  end

  def bill_share_params
    params.permit(:user_id, :friend_id)
  end

  def token_params
    params.permit(:token)
  end

end
