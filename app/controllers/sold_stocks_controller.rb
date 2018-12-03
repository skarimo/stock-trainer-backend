class SoldStocksController < ApplicationController

  def sell_stock
    @user = User.find(params[:user_id])

    @stock = Stock.find_by(symbol: params[:symbol])

    @liveData = @stock.getLiveData

    @owned_stock_share = @user.owned_stock_shares.find_by(stock_id: @stock.id)
    @sold_stock_card = @user.sold_stocks.new(stock_id: @stock.id)

    @new_owned_shares = (@owned_stock_share.owned_shares - params["shares_amount"].to_i)
    @owned_stock_share.update(owned_shares: @new_owned_shares)
    stock_broadcast("UPDATED", @owned_stock_share, "OWNED_STOCK_SHARES")

    if @owned_stock_share.owned_shares == 0
      stock_broadcast("DESTROYED", @owned_stock_share, "OWNED_STOCK_SHARES")
      @owned_stock_share.destroy
    end

    @new_pending_sale_shares = @sold_stock_card.pending_sale_shares.to_i + params["shares_amount"].to_i
    @sold_stock_card.update(status_id: 2, pending_sale_shares: @new_pending_sale_shares)
    @sold_stock_card.save
    @sold_stock_card.sell(@owned_stock_share.id, @liveData["latestVolume"], @liveData["latestPrice"], params["share_price"], params["shares_amount"])
        render json: @sold_stock_card
  end

  def destroy
    @sold_stock = SoldStock.find(params[:id])
    @sold_stock.destroy
    render json: {message: "task completed"}
  end

  def cancel_sale
    @sold_stock = SoldStock.find(params[:id])
    @owned_stock_share = OwnedStockShare.find_or_initialize_by(user_id: @sold_stock.user.id, stock_id: @sold_stock.stock.id)

      if @sold_stock.pending_sale_shares != 0
        @new_owned_shares = @sold_stock.pending_sale_shares + @owned_stock_share.owned_shares
        @owned_stock_share.update(owned_shares: @new_owned_shares)
        stock_broadcast("UPDATED", @owned_stock_share, "OWNED_STOCK_SHARES")

        if @owned_stock_share.owned_shares == 0 
          stock_broadcast("DESTROYED", @owned_stock_share, "OWNED_STOCK_SHARES")
          @owned_stock_share.destroy
        end
        @sold_stock.update!(status_id: 3, pending_sale_shares: 0)
        stock_broadcast("UPDATED", @sold_stock, "SOLD_STOCKS")
      else
        @sold_stock.update!(status_id: 1)
        stock_broadcast("UPDATED", @sold_stock, "SOLD_STOCKS")
      end
    render json: {"stock_card": @sold_stock, "status":@sold_stock.status, "stock": @sold_stock.stock, "new_owned_shares": @new_owned_shares}
  end
end
