# frozen_string_literal: true

require 'pp'
# API endpoints for the collection and distribution of select news articles
class API::ArticlesController < ApplicationController
  def index; end

  def search; end

  def bias
    if Article.count < 1
      articles_average = {
        :libertarian => 1,
        :green => 1,
        :liberal => 1,
        :conservative => 1
      }
    else
      articles_average = Article.averages
    end
    render json: articles_average.to_h
  end

  private

  def article_params
    params.permit(:search_terms, :number_of_articles)
  end
end
