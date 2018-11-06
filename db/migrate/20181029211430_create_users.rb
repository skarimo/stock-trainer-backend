class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.decimal :account_balance, :precision => 40, :scale => 4, :default => 0
      t.string :email
      t.string :password_digest
      t.timestamps
    end
  end
end
