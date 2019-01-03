class PurchasedStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  belongs_to :status

  def sleep_time_calculator(volume, stock_current_price, offered_price)
    #(sleep_volume, price_diff)
    v1 = stock_current_price.to_f
    v2 = offered_price.to_f

    price_diff = (v1 - v2)/((v2+v1)/2).to_f

    if price_diff < 0
      price_diff_sleep_time = (0.1 / price_diff).abs
    elsif price_diff > 0
      price_diff_sleep_time = 1000 * price_diff
    else
      price_diff_sleep_time = rand(1..40)
    end

    volume_sleep_time = 1000000/volume

    return (price_diff_sleep_time + volume_sleep_time)
  end

  def buy(volume, stock_current_price, offered_price, shares_amount)
    @random_sleep_time = self.sleep_time_calculator(volume, stock_current_price, offered_price)

    @owned_stock_share = OwnedStockShare.find_by(stock_id: self.stock.id, user_id: self.user.id)
      if !@owned_stock_share
        @owned_stock_share = OwnedStockShare.create!(stock_id: self.stock.id, user_id: self.user.id)

        stock_broadcast("CREATED", @owned_stock_share, "OWNED_STOCK_SHARES")
      end

    x = Thread.new{
      while self.pending_buy_shares != 0
        if @random_sleep_time > 1
          rand_time=rand(1..@random_sleep_time.to_f)
        else
          rand_time = @random_sleep_time
        end
        sleep(rand_time)
          purchased_stock_card = PurchasedStock.find(self.id)
          rand_shares = rand(1..purchased_stock_card.pending_buy_shares)

          if purchased_stock_card.pending_buy_shares != 0
            new_purchased_shares = purchased_stock_card.owned_shares + rand_shares.to_i
            new_pending_buy_shares = purchased_stock_card.pending_buy_shares - rand_shares

            @new_avg_buy_price = (@owned_stock_share.owned_shares * @owned_stock_share.avg_buy_price + rand_shares * offered_price.to_f)/(rand_shares + @owned_stock_share.owned_shares)

            @new_owned_shares = rand_shares + @owned_stock_share.owned_shares

            @owned_stock_share.update(owned_shares: @new_owned_shares, avg_buy_price: @new_avg_buy_price)
            purchased_stock_card.update(owned_shares: new_purchased_shares, pending_buy_shares: new_pending_buy_shares)
            stock_broadcast("UPDATED", @owned_stock_share, "OWNED_STOCK_SHARES")
            stock_broadcast("UPDATED", purchased_stock_card, "PURCHASED_STOCKS")

          elsif purchased_stock_card.owned_shares == shares_amount.to_i
            purchased_stock_card.update!(status_id: 1)
            stock_broadcast("UPDATED", purchased_stock_card, "PURCHASED_STOCKS")
            x.kill
          else
            stock_broadcast("UPDATED", purchased_stock_card, "PURCHASED_STOCKS")
            x.kill
          end
      end
     }
  end

end
