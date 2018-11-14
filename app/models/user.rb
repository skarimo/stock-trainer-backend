require 'net/http'

class User < ApplicationRecord
   #Validations
   validates_presence_of :email, :password_digest, :first_name, :last_name
   validates :email, uniqueness: true
   validates :username, uniqueness: true
   has_secure_password
   validates :password, length: { minimum: 6, maximum: 15 }, on: :create

   has_many :purchased_stocks
   has_many :watchlists
   has_many :sold_stocks
   has_many :owned_stock_shares
   has_many :stocks, through: :purchased_stocks
   has_many :stocks, through: :sold_stocks
   has_many :stocks, through: :watchlists
   has_many :stocks, through: :owned_stock_shares

   # http = Net::HTTP.new("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{purchased_stocks.stock.symbol}&types=quote", 443)

  def todays_gain
    balance = self.account_balance

    self.purchased_stocks.each do |purchased_stocks|
      url = URI.("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{purchased_stocks.stock.symbol}&types=quote").read
      uri = URI(url)
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(uri.hostname, uri.port) {|http|http.request(req)}
      parsed_data = JSON.parse(res.body)
    end

  end
end
