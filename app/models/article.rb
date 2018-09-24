class Article < ApplicationRecord

  has_many :votes
  has_many :users, through: :votes

  has_one :bias, as: :biasable

  attr_accessor :bias_structure, :articles_bias

  after_create :retrieve_bias

  @articles_bias = Struct.new(:libertarian, :green, :liberal, :conservative)

  def self.averages
    @articles_bias.new(
      Article.traverse_association(:bias).average('libertarian'),
      Article.traverse_association(:bias).average('green'),
      Article.traverse_association(:bias).average('liberal'),
      Article.traverse_association(:bias).average('conservative')
    )
  end

  private

  def create
    run_callbacks :create do
      retrieve_bias
    end
  end

  def retrieve_bias
    Vendor.init_indico
    the_bias = Indico.political(body).deep_transform_keys(&:downcase).deep_symbolize_keys
    self.bias = Bias.create(the_bias)
  end
end
