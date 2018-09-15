class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :article

  has_one :bias, as: :biasable

  after_create :get_bias, :update_user_bias

  private

  def get_bias
    parties = %i[libertarian green liberal conservative]
    artBias = self.article.bias.slice(parties).deep_symbolize_keys
    vote = self.vote
    case (vote)
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
    self.user.update_user_bias
  end
end
