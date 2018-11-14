# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'net/http'

uri = URI.parse("https://api.iextrading.com/1.0/ref-data/symbols")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
res = http.get(uri.request_uri)
parsed_data = JSON.parse(res.body)
  parsed_data.each do |stock|
    if stock["isEnabled"] == true
      Stock.create(symbol: stock["symbol"], name: stock["name"], date: stock["date"], isEnabled: stock["isEnabled"], stock_type: stock["type"], iexId: stock["iexId"])
    end
  end

Status.create(id: 1, name: "COMPLETED")
Status.create(id: 2, name: "PENDING")
Status.create(id: 3, name: "CANCELED")

User.create(first_name: "Mike", last_name: "Stance", username: "123", email: "123", account_balance: 100.00, password: "123")

# OwnedStockShare.create(user_id: 1, stock_id: 10, owned_shares: 200)
# OwnedStockShare.create(user_id: 1, stock_id: 15, owned_shares: 100)
# OwnedStockShare.create(user_id: 1, stock_id: 20, owned_shares: 150)
# OwnedStockShare.create(user_id: 1, stock_id: 30, owned_shares: 200)


# SoldStock.create(user_id: 1, stock_id: 150, sold_shares: 20, pending_sale_shares: 36, sale_price: 100, status_id: 2)
# SoldStock.create(user_id: 1, stock_id: 200, sold_shares: 10, pending_sale_shares: 12, sale_price: 100, status_id: 2)
# SoldStock.create(user_id: 1, stock_id: 325, sold_shares: 450, pending_sale_shares: 50, sale_price: 100, status_id: 2)
# SoldStock.create(user_id: 1, stock_id: 225, sold_shares: 5, pending_sale_shares: 5, sale_price: 100, status_id: 2)

Watchlist.create(user_id: 1, stock_id: 100)
Watchlist.create(user_id: 1, stock_id: 1000)
Watchlist.create(user_id: 1, stock_id: 5)
Watchlist.create(user_id: 1, stock_id: 98)
