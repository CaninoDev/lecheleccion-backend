class Article < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes

  has_one :bias, as: :biasable

  after_create :retrieve_bias
  attr_accessor :bias_structure

  Struct.new("ArticleBias", :libertarian, :green, :liberal, :conservative)


  def self.averages
    Struct::ArticleBias.new(
      Article.traverse_association(:bias).average('libertarian'),
      Article.traverse_association(:bias).average('green'),
      Article.traverse_association(:bias).average('liberal'),
      Article.traverse_association(:bias).average('conservative')
    )
  end

  private

  def retrieve_bias
    Vendor.init_indico
    theBias = Indico.political(self.body).deep_transform_keys(&:downcase).deep_symbolize_keys
    self.bias = Bias.create(theBias)
  end
end
