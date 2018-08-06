class User < ApplicationRecord
  has_many :articles
  
  has_many :votes
  has_many :votes, through: :articles
end
