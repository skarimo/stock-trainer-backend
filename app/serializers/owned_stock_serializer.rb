class OwnedStockSerializer < ActiveModel::Serializer
  attributes :id, :owned_shares, :pending_buy_shares, :buy_price, :status, :stock
end
