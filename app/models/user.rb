require 'net/http'

class User < ApplicationRecord
   #Validations
   validates_presence_of :email, :password_digest
   validates :email, uniqueness: true
   has_secure_password

   has_many :owned_stocks
   has_many :watchlists
   has_many :sold_stocks
   has_many :stocks, through: :owned_stocks
   has_many :stocks, through: :sold_stocks
   has_many :stocks, through: :watchlists

   # http = Net::HTTP.new("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{owned_stock.stock.symbol}&types=quote", 443)

  def todays_gain
    balance = self.account_balance

    self.owned_stocks.each do |owned_stock|
      url = URI.("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{owned_stock.stock.symbol}&types=quote").read
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(uri.hostname, uri.port) {|http|http.request(req)}
      parsed_data = JSON.parse(res.body)
      byebug
    end

  end
end
