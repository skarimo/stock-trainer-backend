class OwnedStock < ApplicationRecord
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

  def buy(volume, stock_current_price, offered_price)
    @random_sleep_time = self.sleep_time_calculator(volume, stock_current_price, offered_price)
    x = Thread.start{
      while self.pending_buy_shares != 0
        if @random_sleep_time > 1
          rand_time=rand(1..@random_sleep_time.to_f)
        else
          rand_time = @random_sleep_time
        end
        rand_shares = rand(1..self.pending_buy_shares)
        sleep(rand_time)
        new_owned_shares = self.owned_shares + rand_shares
        new_pending_buy_shares = self.pending_buy_shares - rand_shares
        new_avg_buy_price = (self.owned_shares * self.buy_price + rand_shares * offered_price.to_f)/new_owned_shares
        self.update(owned_shares: new_owned_shares, pending_buy_shares: new_pending_buy_shares, buy_price: new_avg_buy_price)
      end
      self.update(status_id: 1)
     }
  end

end

# random_constant = 1000
# if price_diff < -10 && price_diff <= -5
#   price_diff_sleep_time = rand(1..100)
# elsif price_diff < 0 && price_diff >= -5
#   price_diff_sleep_time = rand(1..5)
# elsif price_diff == 0
#   price_diff_sleep_time = rand(1..100)
# else
#   price_diff_sleep_time = random_constant*price_diff
# end
#
#   if price_diff*100 < 0 && price_diff*100 < 5
#     price_diff_sleep_time = rand(1..10)
#   elsif price_diff < 0
#     price_diff_sleep_time = rand(1..1)
#   end
#
# volume_constant = 0.0000001
#
# volume_sleep_time = 1 / (volume * volume_constant)
#volume sleep random number
