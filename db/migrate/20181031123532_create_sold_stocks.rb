class CreateSoldStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :sold_stocks do |t|
      t.integer :user_id
      t.integer :stock_id
      t.integer :sold_shares, :default => 0
      t.integer :pending_sale_shares, :default => 0
      t.decimal :sale_price, :precision => 40, :scale => 4, :default => 0
      t.integer :status_id
      t.timestamps
    end
  end
end
