# frozen_string_literal: true

class Vote < ApplicationRecord


  belongs_to :user
  belongs_to :article

  has_one :bias, as: :biasable

  after_create :retrieve_bias, :update_user_bias

  private

  def retrieve_bias
    parties = %i[libertarian green liberal conservative]
    article_bias = article.bias.slice(parties).deep_symbolize_keys
    vote = self.vote
    the_bias = case vote
               when -1
                 article_bias.transform_values { |v| v/2 }
               when 0
                 article_bias
               when 1
                 article_bias.transform_values { |v| v/2 }
               else
                 article_bias
               end
    self.bias = Bias.create(the_bias)
  end

  def update_user_bias
    user.update_user_bias
  end
end
