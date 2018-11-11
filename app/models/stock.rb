require "net/http"
require "uri"
require 'json'


class Stock < ApplicationRecord
  has_many :owned_stocks
  has_many :watchlists


  def getLiveData
    uri = URI.parse("https://api.iextrading.com/1.0/stock/#{self.symbol}/quote")
    response = Net::HTTP.get_response(uri)
    liveData = JSON[response.body]
    return liveData
  end

end



# https://api.iextrading.com/1.0/stock/aapl/quote
