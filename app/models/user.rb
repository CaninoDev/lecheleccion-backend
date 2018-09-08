class User < ApplicationRecord
  has_many :votes
  has_many :articles, through: :votes
  has_one :bias, as: :biasable
end
