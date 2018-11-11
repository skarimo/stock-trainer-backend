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
    @user.owned_stocks.create(stock_id: 331, owned_shares: 10, status_id: 1)
    @user.owned_stocks.create(stock_id: 7892, owned_shares: 10, status_id: 1)
    @user.owned_stocks.create(stock_id: 5514, owned_shares: 10, status_id: 1)
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
    @owned_stock = @user.owned_stocks
    @sold_stocks = @user.sold_stocks
    render json: {"owned_stocks": @owned_stock, "sold_stocks": @sold_stocks}
  end

  def authorize_token
    @user_id = JsonWebToken.decode(request.headers["Authorization"])["user_id"]
    @user = User.find(@user_id)
    render json: @user
  end


private

# user: {account_balance: @user.account_balance, email: @user.email, first_name: @user.first_name, id: @user.id, last_name: @user.last_name, owned_stocks: @user.owned_stocks, username: @user.username, watchlists: @user.watchlists}


  def authenticate(username, password)
    command = AuthenticateUser.call(username, password)
    if command.success?
      @user = User.find(JsonWebToken.decode(command.result)["user_id"])
      render json: {
        access_token: command.result,
        user: {account_balance: @user.account_balance, email: @user.email, first_name: @user.first_name, id: @user.id,  username: @user.username, last_name: @user.last_name,
          watchlists: @user.watchlists.map{|stock| {id: stock.id, stock: stock}
        },
        owned_stocks:  @user.owned_stocks.map{|owned_stock| {
          id: owned_stock.id,
          owned_shares: owned_stock.owned_shares,
          pending_buy_shares: owned_stock.pending_buy_shares,
          buy_price: owned_stock.buy_price,
          status: owned_stock.status,
          stock: owned_stock.stock
        }},
        sold_stocks:  @user.sold_stocks.map{|sold_stock| {
          id: sold_stock.id,
          sold_shares: sold_stock.sold_shares,
          pending_sale_shares: sold_stock.pending_sale_shares,
          sale_price: sold_stock.sale_price,
          status: sold_stock.status,
          stock: sold_stock.stock
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
