class Article < ApplicationRecord
  has_many :users

  has_many :votes
  has_many :votes, through: :users
end
