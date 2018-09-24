# frozen_string_literal: true

require 'pp'
# API endpoints for the collection and distribution of select news articles
class API::ArticlesController < ApplicationController
  def index
  end

  def search
  end

  def bias
    articles_average = Article.averages
    render json: articles_average.to_json
  end

  private

  def article_params
    params.permit(:search_terms, :number_of_articles)
  end
end
