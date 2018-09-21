# frozen_string_literal: true

require 'pp'
# API endpoints for the collection and distribution of select news articles
class API::ArticlesController < ApplicationController

  def index
    # news_collection = Vendor.get_news_articles
    # processed_collection = preprocess(news_collection)
    # json_response(processed_collection)
    @articles = Article.all
    json_response(@articles)
  end

  def search
    news_collection = Vendor.get_news_articles params[:search_term]
    processed = preprocess(news_collection)
    json_response(processed)
  end

  def bias
    @articles_average = Article.averages
    json_response(@articles_average)
  end

  private

  def preprocess articles
    prefiltered_articles = prefilter(articles)
    create_article_records(prefiltered_articles)
  end

  def create_article_records articles
    articles.map do |article|
      Article.create(
        title: article.title,
        source: article.source.name,
        body: article.body,
        url: article.links.permalink,
        urlToImage: article.media[0].url,
        publication_date: article.published_at,
        external_reference_id: article.id
      )
    end
  end

  def prefilter articles
    articles.stories.reject { |article| article.body.length < 400 || article.title.length < 1}
  end

  def article_params
    params.permit(:search_terms, :number_of_articles)
  end
end
