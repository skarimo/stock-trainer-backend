# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_12_001827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "owned_stock_shares", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stock_id"
    t.integer "owned_shares", default: 0
    t.decimal "avg_buy_price", precision: 40, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchased_stocks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stock_id"
    t.integer "owned_shares", default: 0
    t.integer "pending_buy_shares", default: 0
    t.decimal "buy_price", precision: 40, scale: 4, default: "0.0"
    t.integer "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sold_stocks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stock_id"
    t.integer "sold_shares", default: 0
    t.integer "pending_sale_shares", default: 0
    t.decimal "sale_price", precision: 40, scale: 4, default: "0.0"
    t.integer "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.string "date"
    t.boolean "isEnabled"
    t.string "stock_type"
    t.string "iexId"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.decimal "account_balance", precision: 40, scale: 4, default: "0.0"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watchlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
