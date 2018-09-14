# Indico respsonse template:
# single output
# {
  # 'libertarian': 0.27192999211817354,
  # 'green': 0.06525078204908323,
  # 'liberal': 0.11033990553871972,
  # 'conservative': 0.5524793202940235
# }
# the threshold is .05 (unlikely)
require 'pp'
module Helpers
  def self.get_article_bias(article)
    Indico.political(sanitize(article.body))
  end

  def self.get_user_bias user
    biases = []
    parties = [:libertarian, :green, :liberal, :conservative]
    user.votes.each do |vote|
      article = Article.find_by_id(vote.article_id)
      case vote[:vote]
      when -1
        biases << article.bias.slice(*parties).transform_values{ |v| v/2 }
      when 0
        biases << article.bias.slice(*parties)
      when 1
        biases << article.bias.slice(*parties).transform_values{|value| value*2}
      end

      byebug
      bias_tot = parties.map{|party| biases.inject(0) {|sum, obj| sum + obj[party]}}
      bias_tot.transform_values{ |v| v/user.votes.count }
    end

    # assign_bias(user, bias)
  end

  def self.parse_matrix bias_obj
    bias_obj.slice(:libertarian, :green, :liberal, :conservative)
  end

  def self.get_aggregate_articles_bias user
    aggregate_matrix = matrix.inject { |leaning, values| leaning.merge(values) { |_, val1, val2| val1 + val2}}
    aggregate_matrix.parse_matrix! { |v| v/matrix.length }
    aggregate_matrix
  end

  def self.sanitize text
    ActionController::Base.helpers.sanitize(text)
  end

  def self.create_bias_response(user, article)
    {read_articles_bias: get_aggregate_articles_bias(user), user_bias: user.bias}
  end

  def self.assign_biases(user, article)
    assign_bias(article, get_article_bias(article))
    assign_bias(user, get_user_bias(user))
  end

  def self.assign_bias(assignee, bias_matrix)
    assignee.bias = Bias.new(
      libertarian: bias_matrix["Libertarian"],
      green: bias_matrix["Green"],
      liberal: bias_matrix["Liberal"],
      conservative: bias_matrix["Conservative"]
    )
  end




end
