class SoldStocksController < ApplicationController

  def destroy
    @sold_stock = SoldStock.find(params[:id])
    @owned_stock = OwnedStock.find_or_initialize_by(stock_id: @sold_stock.stock_id)
    @new_owned_stock = @sold_stock.pending_sale_shares + @owned_stock.owned_shares
    @owned_stock.update(owned_shares: @new_owned_stock)
    @sold_stock.destroy
    render json: {message: "success"}
  end
end
