class SoldStockSerializer < ActiveModel::Serializer
  attributes :id, :sold_shares, :pending_sale_shares, :sale_price, :status, :stock, :created_at
end
