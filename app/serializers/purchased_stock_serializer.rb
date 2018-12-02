class PurchasedStockSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :owned_shares, :pending_buy_shares, :buy_price, :status, :stock, :created_at
end
