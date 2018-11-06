class CreateOwnedStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :owned_stocks do |t|
      t.integer :user_id
      t.integer :stock_id
      t.integer :owned_shares
      t.integer :pending_buy_shares
      t.decimal :buy_price, :precision => 40, :scale => 4
      t.integer :status_id
      t.timestamps
    end
  end
end
