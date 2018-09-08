# frozen_string_literal: true

require 'securerandom'
require 'pp'
# API endpoints for the collection and distribution of select news articles
class API::ArticlesController < ApplicationController

  @@articles_cache = []

  def self.cache
    @@articles_cache
  end

  def index
    news_collection = Vendor.get_news_articles
    processed = preprocess(news_collection)
    render json: processed
  end

  def search
    news_collection = Vendor.get_news_articles params[:search_term]
    processed = preprocess(news_collection)
    render json: processed
  end


  private

  def preprocess articles
    prefiltered_articles = prefilter(articles)
    prefiltered_articles.map! do |article|
      Article.create(
        id: SecureRandom.uuid,
        title: article.title,
        source: article.source.name,
        body: article.body,
        url: article.links.permalink,
        urlToImage: article.media[0].url,
        publication_date: article.published_at,
      )
    end
    prefiltered_articles
  end

  def prefilter articles
    articles.stories.reject { |article| article.body.length < 400 }
  end

  def article_params
    params.permit(:search_term, :article_id, :vote)
  end
end
