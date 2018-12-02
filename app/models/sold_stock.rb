class SoldStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  belongs_to :status

  def sleep_time_calculator(volume, stock_current_price, offered_price)
    #(sleep_volume, price_diff)
    v1 = stock_current_price.to_f
    v2 = offered_price.to_f

    price_diff = (v2 - v1)/((v2+v1)/2).to_f

    if price_diff < 0
      price_diff_sleep_time = (0.1 / price_diff).abs
    elsif price_diff > 0
      price_diff_sleep_time = 1000 * price_diff
    else
      price_diff_sleep_time = rand(1..40)
    end

    volume_sleep_time = 10000/volume.to_f

    return (price_diff_sleep_time + volume_sleep_time)
  end


  def sell(purchased_stocks_card_id, volume, stock_current_price, offered_price, shares_to_sell)
    @random_sleep_time = self.sleep_time_calculator(volume, stock_current_price, offered_price)
    @owned_stock_share = OwnedStockShare.find_or_initialize_by(user_id: self.user.id, stock_id: self.stock.id)
    self.update(sale_price: offered_price.to_f)
    sold_stock = SoldStock.find(self.id)
    stock_broadcast("UPDATED", sold_stock, "SOLD_STOCKS")

      x = Thread.new {
        while self.pending_sale_shares != 0
            if @random_sleep_time > 1
              rand_time=rand(1..@random_sleep_time.to_f)
            else
              rand_time = @random_sleep_time
            end

          sleep(rand_time)
          sold_card = SoldStock.find(self.id)
            if sold_card.pending_sale_shares != 0
              rand_shares = rand(1..sold_card.pending_sale_shares)

              new_sold_shares = sold_card.sold_shares + rand_shares

              new_balance = (sold_card.user.account_balance + (rand_shares.to_i * offered_price.to_f))

              sold_card.user.update!(account_balance: new_balance)

              new_pending_sale_shares = sold_card.pending_sale_shares - rand_shares

              sold_card.update!(status_id: 2, sold_shares: new_sold_shares, pending_sale_shares: new_pending_sale_shares)
              stock_broadcast("UPDATED", sold_card, "SOLD_STOCKS")

            elsif (sold_card.sold_shares == shares_to_sell.to_i)
              sold_card.update!(status_id: 1)
              stock_broadcast("UPDATED", sold_card, "SOLD_STOCKS")
              x.kill
            else
              x.kill
            end
       end
      }
  end
end
