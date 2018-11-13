class SoldStocksController < ApplicationController

  def sell_stock
    @user = User.find(params[:user_id])

    @stock = Stock.find_by(symbol: params[:symbol])

    @liveData = @stock.getLiveData

    @owned_stock_share = @user.owned_stock_shares.find_by(stock_id: @stock.id)
    @sold_stock_card = @user.sold_stocks.new(stock_id: @stock.id)

    @new_owned_shares = (@owned_stock_share.owned_shares.to_i - params["shares_amount"].to_i)
    @owned_stock_share.update(owned_shares: @new_owned_shares)

    if @owned_stock_share.owned_shares == 0
      @owned_stock_share.destroy
    end

    @new_pending_sale_shares = @sold_stock_card.pending_sale_shares + params["shares_amount"].to_i
    @sold_stock_card.update(status_id: 2, pending_sale_shares: @new_pending_sale_shares)
    @sold_stock_card.save
    @sold_stock_card.sell(@owned_stock_share.id, @liveData["latestVolume"], @liveData["latestPrice"], params["share_price"], params["shares_amount"])

    @new_user_balance = @user.account_balance
        render json: @sold_stock_card
  end



  def cancel_sale
    @sold_stock = SoldStock.find(params[:id])
    @owned_stock_share = OwnedStockShare.find_or_initialize_by(user_id: @sold_stock.user.id, stock_id: @sold_stock.stock.id)

      if @sold_stock.pending_sale_shares != 0
        @new_owned_shares = @sold_stock.pending_sale_shares + @owned_stock_share.owned_shares
        @owned_stock_share.update(owned_shares: @new_owned_shares)
        if @owned_stock_share.owned_shares == 0
          @owned_stock_share.destroy
        end
        @sold_stock.update!(status_id: 3, pending_sale_shares: 0)
      else
        @sold_stock.update!(status_id: 1)
      end
    render json: {"stock_card": @sold_stock, "status":@sold_stock.status, "stock": @sold_stock.stock, "new_owned_shares": @new_owned_shares}
  end
end
