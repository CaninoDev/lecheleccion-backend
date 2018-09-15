class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :article

  has_one :bias, as: :biasable

  after_create :get_bias, :update_user_bias

  private

  def get_bias
    parties = %i[libertarian green liberal conservative]
    artBias = self.article.bias.slice(parties).deep_symbolize_keys
    case self.vote
    when -1
      theBias = artBias.transform_values { |v| v/2 }
    when 0
      theBias = artBias
    when 1
      theBias = artBias.transform_values { |v| v/2 }
    end
    self.bias = Bias.create(theBias)
  end


  def update_user_bias
    ave_bias = {}
    parties = [:libertarian, :green, :liberal, :conservative]
    biases = self.user.votes.map {|v| v.bias.slice(parties)}
    biases.map!(&:deep_symbolize_keys)
    parties.each{|party| ave_bias[party] = biases.each.inject(0){|sum, obj| sum + obj[party]}}
    theBias = ave_bias.transform_values{ |v| v/self.user.votes.count }
    if self.user.bias == nil
      self.user.bias = Bias.create(theBias)
    else
      self.user.bias.update(theBias)
    end
  end
end
