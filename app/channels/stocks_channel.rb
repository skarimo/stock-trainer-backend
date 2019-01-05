class StocksChannel < ApplicationCable::Channel
  def subscribed
    stream_from "stocks_channel_#{current_user.id}"
  end
end
