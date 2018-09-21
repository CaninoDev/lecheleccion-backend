class User < ApplicationRecord
  has_many :votes
  has_many :articles, through: :votes
  has_one :bias, as: :biasable


  def get_bias
    self.bias
  end

  def update_user_bias
    ave_bias = {}
    parties = %i[libertarian green liberal conservative]
    biases = self.votes.map {|v| v.bias.slice(parties)}
    biases.map!(&:deep_symbolize_keys)
    parties.each{|party| ave_bias[party] = biases.each.inject(0){|sum, obj| sum + obj[party]}}
    the_bias = ave_bias.transform_values{ |v| v/self.votes.count }
    if self.bias == nil
      self.bias = Bias.create(the_bias)
    else
      self.bias.update(the_bias)
    end
  end
end
