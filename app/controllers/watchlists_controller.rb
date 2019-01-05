class WatchlistsController < ApplicationController

  def add_watchlist
    @user = User.find(params["user_id"])
    @stock = Stock.find_by(symbol: params["stock_symbol"])

    @watchlist = @user.watchlists.find_by(stock: @stock)
      if @watchlist
        render json: {already_added: true}
      else
        @new_watchlist = @user.watchlists.create(stock: @stock)
        @live_data = @stock.getLiveData

        render json: {"stock_card": @new_watchlist, "stock": @stock, "liveStockData": @live_data}
     end
  end


  def remove_watchlist
    @user = User.find(params["user_id"])
    @stock = Stock.find_by(symbol: params["stock_symbol"])
    @user.watchlists.find_by(stock_id: @stock.id).destroy
      render json: {"deleted": true}
  end

end
