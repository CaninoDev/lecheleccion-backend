module Bias
  def get_bias(article)
    article.bias = rand(-1.0..1.0)
    article
  end
end
