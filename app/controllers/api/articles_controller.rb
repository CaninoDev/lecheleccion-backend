require 'securerandom'
class API::ArticlesController < ApplicationController
  @@articlesCache = []
  
  def index
    

  end

  def create
    @article = get_bias(@@articlesCache.find { |item| item.uuid == article_params.uuid })
    @article.vote = 0
  end

  def show
  end

  def fetchNews
    top_headlines = gather_collection
    json_response(top_headlines)
  end

  private

  def gather_collection
    newsapi = News.new(Rails.application.credentials.googlenews[:api_key])
    articles = newsapi.get_top_headlines(
      category: 'politics',
      language: 'en',
      country: 'us'
    )
    cacheArticles(articles)
  end

  def cacheArticles(articles)
    articles.map do |article|
      art_obj = Article.new(
        :title => article.title, 
        :body => article.description, 
        :url => article.url,
        :urlToImage => article.urlToImage,
        :publication_date => article.publishedAt,
        :uuid => SecureRandom.uuid)
      @@articlesCache << art_obj
      art_obj
    end
  end

  def article_params
    params.require(:article).permit(:uuid)
  end
end
