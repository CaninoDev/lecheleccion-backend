require 'securerandom'


class API::ArticlesController < ApplicationController

  @articles_cache = []


  def index
    @newsapi = News.new(Rails.application.credentials.googlenews[:api_key])
    news_collection = @newsapi.get_top_headlines(country: 'us', pageSize: 50)
    preprocess(news_collection)
    # Article.all.each do |article|
    #   @articles_cache << article
    # end
    render json: news_collection
  end

  def create
    @vote = Vote.new(
      article_id: params[:article_id],
      user_id: params[:user_id],
      vote: params[:vote])
  end

  def search
    news_collection = newsapi.get_everything(q: params[:search_term], langage: 'en')
    preprocess_articles(news_collection)
    render json: news_collection
  end

  private

  def preprocess articles, user = ''
    articles.map! do |article|
      if article.description then
        art_obj = Article.new(
          id: SecureRandom.uuid,
          source: article.name,
          title: article.title,
          body: article.description,
          url: article.url,
          urlToImage: article.urlToImage,
          publication_date: article.publishedAt,
        )
        # @xarticles_cache << art_obj
        art_obj
      end
    end.compact!
  end

  def postprocess article
    tt = Aylien::TextAnalysisHelper.init
    article_content = tt.extract(url: article.url)[:article]
    article.bias = Indico.political(article_content)
    # topics_categorization = textrazor_categorization(article_content)
  end

  def textrazor_categorization
    options = {
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'X-TextRazor-Key' => Rails.application.credentials.textrazor[:api_key]
      },
      body: {
        'extractors' => 'topics'
      }
    }
    fetch('https://api.textrazor.com', options)
  end

  def article_params
    params.permit(:user_id, :search_term, :article_id, :vote)
  end
end