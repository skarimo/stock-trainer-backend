class OwnedStocksController < ApplicationController


  def buy_stock
    @user = User.find(params[:user_id])
    @new_user_balance = @user.account_balance - (params["shares_amount"].to_i * params["share_price"].to_f)
    @user.update(account_balance: @new_user_balance)
    @stock = Stock.find_by(symbol: params[:symbol])
    @liveData = @stock.getLiveData

    @owned_stock_card = @user.owned_stocks.find_or_initialize_by(stock_id: @stock.id)

    @new_pending_owned_shares = @owned_stock_card.pending_buy_shares + params["shares_amount"].to_i

    # @new_avg_buy_price = (@owned_stock_card.owned_shares * @owned_stock_card.buy_price + params["shares_amount"].to_i * params["share_price"].to_f)/@new_owned_shares
    @owned_stock_card.update(status_id: 2, pending_buy_shares: @new_pending_owned_shares)
    @owned_stock_card.save
    #create the thread and run the loop
    @owned_stock_card.buy(@liveData["latestVolume"], @liveData["latestPrice"], params["share_price"])
    #---------------------------------------

    # @return_data = {@owned_stock_card, liveStockData:{quote: p}}
    render json: {"stock_card": @owned_stock_card, "stock": @owned_stock_card.stock, "liveStockData": @liveData, "new_balance":@new_user_balance}
  end

  def sell_stock
    @user = User.find(params[:user_id])

    @stock = Stock.find_by(symbol: params[:symbol])

    @liveData = @stock.getLiveData

    @owned_stock_card = @user.owned_stocks.find_by(stock_id: @stock.id)
    @sold_stock_card = @user.sold_stocks.new(stock_id: @stock.id)

    @new_owned_shares = (@owned_stock_card.owned_shares.to_i - params["shares_amount"].to_i)
    @owned_stock_card.update(owned_shares: @new_owned_shares)

    @new_pending_sale_shares = @sold_stock_card.pending_sale_shares + params["shares_amount"].to_i
    @sold_stock_card.update(status_id: 1, pending_sale_shares: @new_pending_sale_shares)
    @sold_stock_card.save
    @sold_stock_card.sell(@owned_stock_card.id, @liveData["latestVolume"], @liveData["latestPrice"], params["share_price"], params["shares_amount"])

    @new_user_balance = @user.account_balance

      if @owned_stock_card.pending_buy_shares == 0 && @owned_stock_card.owned_shares == 0
        @owned_stock_card.destroy
        render json: {message: 'No more shares left', "new_balance": @new_user_balance}
      else
        render json: {"stock_card": @owned_stock_card, "stock": @owned_stock_card.stock, "liveStockData": @liveData, "new_balance": @new_user_balance, "sold_stock_card": {"id": @sold_stock_card.id, "stock": @sold_stock_card.stock, "pending_sale_shares": @sold_stock_card.pending_sale_shares,
          "sale_price": @sold_stock_card.sale_price, "sold_shares": @sold_stock_card.sold_shares, "created_at": @sold_stock_card.created_at, "status": @sold_stock_card.status, "user_id": @sold_stock_card.user_id}}
      end
  end

end



# @owned_stock_card.owned_shares * @owned_stock_card.buy_price + params["shares_amount"].to_i * params["share_price"].to_f/
