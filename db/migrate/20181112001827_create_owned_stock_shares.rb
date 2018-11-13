class CreateOwnedStockShares < ActiveRecord::Migration[5.2]
  def change
    create_table :owned_stock_shares do |t|
      t.integer :user_id
      t.integer :stock_id
      t.integer :owned_shares, :default => 0
      t.decimal :avg_buy_price, :precision => 40, :scale => 4, :default => 0
      t.timestamps
    end
  end
end
