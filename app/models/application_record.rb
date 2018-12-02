class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def stock_broadcast(action, stock_card, location)
    if location == "OWNED_STOCK_SHARES"
      @stock_card = OwnedStockShareSerializer.new(OwnedStockShare.find(stock_card.id))
    elsif location == "PURCHASED_STOCKS"
      @stock_card = PurchasedStockSerializer.new(PurchasedStock.find(stock_card.id))
    elsif location == "SOLD_STOCKS"
      @stock_card = SoldStockSerializer.new(SoldStock.find(stock_card.id))
    end

    ActionCable.server.broadcast \
  "stocks_channel_#{stock_card.user.id}", {action: action, stock: @stock_card, location: location}


  end
end
