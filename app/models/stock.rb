require "net/http"
require "uri"
require 'json'


class Stock < ApplicationRecord
  has_many :purchased_stocks
  has_many :watchlists

  def getLiveData
    #fetches live stock data from api
    uri = URI.parse("https://api.iextrading.com/1.0/stock/#{self.symbol}/quote")
    response = Net::HTTP.get_response(uri)
    liveData = JSON[response.body]
    return liveData
  end

end
