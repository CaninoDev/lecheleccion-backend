class Article < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes
  has_one :bias, as: :biasable
end
