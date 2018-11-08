class OwnedStocksController < ApplicationController


  def buy_stock
    @user = User.find(params[:user_id])
    @new_user_balance = @user.account_balance - (params["shares_amount"].to_i * params["share_price"].to_f)

    @user.update(account_balance: @new_user_balance)
    @stock = Stock.find_by(symbol: params[:liveData][:symbol])
    @owned_stock_card = @user.owned_stocks.find_or_initialize_by(stock_id: @stock.id)
      @new_owned_shares = @owned_stock_card.owned_shares + params["shares_amount"].to_i


      @new_avg_buy_price = (@owned_stock_card.owned_shares * @owned_stock_card.buy_price + params["shares_amount"].to_i * params["share_price"].to_f)/@new_owned_shares
    @owned_stock_card.update(status_id: 1, owned_shares: @new_owned_shares, buy_price: @new_avg_buy_price)
    @owned_stock_card.save
    # @return_data = {@owned_stock_card, liveStockData:{quote: p}}
    render json: {"stock_card": @owned_stock_card, "stock": @owned_stock_card.stock, "liveStockData": params["liveData"], "new_balance":@new_user_balance}
  end

  def sell_stock

  end

end



# @owned_stock_card.owned_shares * @owned_stock_card.buy_price + params["shares_amount"].to_i * params["share_price"].to_f/
