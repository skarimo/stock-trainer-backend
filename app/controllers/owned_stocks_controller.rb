class OwnedStocksController < ApplicationController


  def buy_stock
    @user = User.find(params[:user_id])
    @new_user_balance = @user.account_balance - (params["shares_amount"].to_i * params["share_price"].to_f)

    @user.update(account_balance: @new_user_balance)

    @stock = Stock.find_by(symbol: params[:symbol])

    @liveData = @stock.getLiveData

    @owned_stock_card = @user.owned_stocks.find_or_initialize_by(stock_id: @stock.id)
      @new_owned_shares = @owned_stock_card.owned_shares + params["shares_amount"].to_i


      @new_avg_buy_price = (@owned_stock_card.owned_shares * @owned_stock_card.buy_price + params["shares_amount"].to_i * params["share_price"].to_f)/@new_owned_shares
    @owned_stock_card.update(status_id: 1, owned_shares: @new_owned_shares, buy_price: @new_avg_buy_price)


    @owned_stock_card.save
    # @return_data = {@owned_stock_card, liveStockData:{quote: p}}
    render json: {"stock_card": @owned_stock_card, "stock": @owned_stock_card.stock, "liveStockData": @liveData, "new_balance":@new_user_balance}
  end

  def sell_stock
    @user = User.find(params[:user_id])
    @new_user_balance = @user.account_balance + (params["shares_amount"].to_i * params["share_price"].to_f)
    @user.update(account_balance: @new_user_balance)

    @stock = Stock.find_by(symbol: params[:symbol])

    @liveData = @stock.getLiveData

    @owned_stock_card = @user.owned_stocks.find_by(stock_id: @stock.id)
      @new_owned_shares = (@owned_stock_card.owned_shares - params["shares_amount"].to_i)

    @owned_stock_card.update(status_id: 1, owned_shares: @new_owned_shares)
    @owned_stock_card.save
      if @new_owned_shares == 0
        @owned_stock_card.destroy
        render json: {message: 'No more shares left', "new_balance": @new_user_balance}
      else
        render json: {"stock_card": @owned_stock_card, "stock": @owned_stock_card.stock, "liveStockData": @liveData, "new_balance": @new_user_balance}
      end
  end

end



# @owned_stock_card.owned_shares * @owned_stock_card.buy_price + params["shares_amount"].to_i * params["share_price"].to_f/
