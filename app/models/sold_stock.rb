class SoldStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  belongs_to :status
end
