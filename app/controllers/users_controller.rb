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
    # @user.owned_stock_shares.create(stock_id: 331, owned_shares: 10)
    # @user.owned_stock_shares.create(stock_id: 7892, owned_shares: 10)
    # @user.owned_stock_shares.create(stock_id: 5514, owned_shares: 10)
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
    render json: {
      account_balance: @user.account_balance,
      purchased_stocks: @user.purchased_stocks.map{|purchased_stocks| PurchasedStockSerializer.new(purchased_stocks)},
      sold_stocks: @user.sold_stocks.map{|purchased_stocks| SoldStockSerializer.new(purchased_stocks)},
      watchlists: @user.watchlists.map{|watchlist| WatchlistSerializer.new(watchlist)},
      owned_stock_shares: @user.owned_stock_shares.map{|owned_stock| OwnedStockShareSerializer.new(owned_stock)}
    }
  end

  # def update_owned
  #   @user = User.find(params[:id])
  #   @owned_stock_shares = @user.owned_stock_shares.map{|owned_stock_share| OwnedStockShareSerializer.new(owned_stock_share)}
  #   render json: @owned_stock_shares
  # end

  def authorize_token
    @user_id = JsonWebToken.decode(request.headers["Authorization"])["user_id"]
    @user = User.find(@user_id)
    render json: @user
  end


private

  def authenticate(username, password)
    command = AuthenticateUser.call(username, password)
    if command.success?
      @user = User.find(JsonWebToken.decode(command.result)["user_id"])
      render json: {
        access_token: command.result,
        user: UserSerializer.new(@user),
        purchased_stocks:  @user.purchased_stocks.map{|purchased_stocks| PurchasedStockSerializer.new(purchased_stocks)},
        sold_stocks:  @user.sold_stocks.map{|sold_stock| SoldStockSerializer.new(sold_stock)},
        owned_stock_shares:  @user.owned_stock_shares.map{|owned_stock_share| OwnedStockShareSerializer.new(owned_stock_share)},
        watchlists:  @user.watchlists.map{|watchlist| WatchlistSerializer.new(watchlist)}
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
