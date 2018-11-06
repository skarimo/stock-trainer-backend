class Stock < ApplicationRecord
  has_many :owned_stocks
  has_many :watchlists
end
