class SoldStockSerializer < ActiveModel::Serializer
  attributes :id,:user_id, :sold_shares, :pending_sale_shares, :sale_price, :status, :stock, :created_at
end
