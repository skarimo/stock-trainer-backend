class OwnedStockShareSerializer < ActiveModel::Serializer
  attributes :id, :owned_shares, :avg_buy_price, :stock
end
