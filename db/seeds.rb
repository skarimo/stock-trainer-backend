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
