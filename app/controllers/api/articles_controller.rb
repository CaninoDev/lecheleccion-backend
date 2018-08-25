require 'securerandom'
require 'news-api'

class API::ArticlesController < ApplicationController

  @@article_cache

  def index
    @@articles_cache
  end

  def create
    @vote = Vote.new(
      article_id: params[:article_id],
      user_id: params[:user_id],
      vote: params[:vote])
  end

  def show
  end

  def fetch_news
    collection = []
    case request.method_symbol
    when :get
      collection = get_top_news
    when :post
      collection = get_searched_news
    end
    cacheArticles(collection)
    render json: collection
  end

  private

  def get_top_news
    apikey = Rails.application.credentials.googlenews[:api_key]
    newsapi = News.new(apikey)
    newsapi.get_top_headlines(language: 'en')
  end

  def get_searched_news
    apikey = Rails.application.credentials.googlenews[:api_key]
    newsapi = News.new(apikey)
    newsapi.get_everything(q: params[:search_term], language: 'en')
  end

  def cacheArticles articles
    articles.map do |article|
      art_obj = Article.new(
        title: article.title,
        body: article.description,
        url: article.url,
        urlToImage: article.urlToImage,
        publication_date: article.publishedAt
      )
      articles_cache << art_obj
      art_obj
    end
  end

  def article_params
    params.permit(:user_id, :search_term, :article_id)
  end
end