require 'securerandom'
require 'news-api'

class API::ArticlesController < ApplicationController
  @@articlesCache = []
  
  def index
    @@articlesCache
  end

  def create
    @article = get_bias(@@articlesCache.find { |item| item.uuid == article_params.uuid })
    @article.vote = 0
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
    json_response(collection)
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

  def cacheArticles (articles)
    articles.map do |article|
      art_obj = Article.new(
        title: article.title,
        body: article.description,
        url: article.url,
        urlToImage: article.urlToImage,
        publication_date: article.publishedAt,
        uuid: SecureRandom.uuid)
      @@articlesCache << art_obj
      art_obj
    end
  end

  def article_params
    params.require(:article).permit(:uuid)
  end
end
