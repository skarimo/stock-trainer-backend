class OwnedStockShareSerializer < ActiveModel::Serializer
  attributes :id,:user_id, :owned_shares, :avg_buy_price, :stock
end
