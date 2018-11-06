class UsersController < ApplicationController
skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate(params["email"], params["password"])
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def register
    @user = User.create(user_params)
   if @user.save
    response = { message: 'User created successfully'}
    render json: response, status: :created
   else
    render json: @user.errors, status: :bad
   end
  end

  def authorize_token
    @user_id = JsonWebToken.decode(request.headers["Authorization"])["user_id"]
    @user = User.find(@user_id)
    render json: @user
  end


private

# user: {account_balance: @user.account_balance, email: @user.email, first_name: @user.first_name, id: @user.id, last_name: @user.last_name, owned_stocks: @user.owned_stocks, username: @user.username, watchlists: @user.watchlists}


  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)
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
    params.permit(:username, :email, :password, :first_name, :last_name, :category_id)
  end

  def bill_share_params
    params.permit(:user_id, :friend_id)
  end

  def token_params
    params.permit(:token)
  end

end
