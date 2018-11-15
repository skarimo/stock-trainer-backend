class PurchasedStocksController < ApplicationController

  def buy_stock
    @user = User.find(params[:user_id])
    @new_user_balance = @user.account_balance - (params["shares_amount"].to_i * params["share_price"].to_f)
    @user.update(account_balance: @new_user_balance)
    @stock = Stock.find_by(symbol: params[:symbol])
    @liveData = @stock.getLiveData

    @purchased_stock_card = @user.purchased_stocks.new(stock_id: @stock.id)

    @purchased_stock_card.update(status_id: 2, pending_buy_shares: params["shares_amount"].to_i, buy_price: params["share_price"].to_f)
    @purchased_stock_card.save
    #create the thread and run the loop
    @purchased_stock_card.buy(@liveData["latestVolume"], @liveData["latestPrice"], params["share_price"], params["shares_amount"])
    #---------------------------------------

    render json: {"stock_card": @purchased_stock_card, "status":@purchased_stock_card.status, "stock": @purchased_stock_card.stock, "new_balance":@new_user_balance}
  end

  def destroy
    @purchased_stock = PurchasedStock.find(params[:id])
    @purchased_stock.destroy
    render json: {message: "task completed"}
  end

  def cancel_purchase
    @purchased_stock = PurchasedStock.find(params[:id])
    @owned_stock_share = OwnedStockShare.find_by(user_id: @purchased_stock.user.id, stock_id: @purchased_stock.stock.id)
      if @purchased_stock.pending_buy_shares != 0
        @new_balance = (@purchased_stock.buy_price * @purchased_stock.pending_buy_shares) + @purchased_stock.user.account_balance
        @purchased_stock.user.update(account_balance: @new_balance)
        @purchased_stock.update!(status_id: 3, pending_buy_shares: 0)
      else
        @purchased_stock.update!(status_id: 1)
      end
      if @owned_stock_share.owned_shares == 0
        @owned_stock_share.destroy
      end

    render json: {"stock_card": @purchased_stock, "status":@purchased_stock.status, "stock": @purchased_stock.stock, "new_balance":@purchased_stock.user.account_balance}
  end

end
