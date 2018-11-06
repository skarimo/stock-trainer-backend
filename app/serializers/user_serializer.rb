class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :username, :account_balance
  has_many :owned_stocks
  has_many :sold_stocks
  has_many :watchlists
end
