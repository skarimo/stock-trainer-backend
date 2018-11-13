class ChangeOwnedStockTableName < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :owned_stocks, :purchased_stocks
  end

  def self.down
    rename_table :purchased_stocks, :owned_stocks
  end
end
