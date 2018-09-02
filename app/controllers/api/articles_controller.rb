require 'securerandom'


class API::ArticlesController < ApplicationController

  @@articles_cache = []


  def index
    # For offline testing
    # Article.all.each do |article|
    #   @articles_cache << article
    # end
    @newsapi = News.new(Rails.application.credentials.googlenews[:api_key])
    news_collection = @newsapi.get_top_headlines(country: 'us', pageSize: 50)
    preprocess(news_collection)
    render json: news_collection
  end

  def create
    article = @articles_cache.find_by_id(params[:article_id])
    postprocess(article)
    @vote = Vote.create(
      article_id: params[:article_id],
      user_id: params[:user_id],
      vote: params[:vote]
    )
    render json: current_user, include: ['articles']
  end

  def search
    news_collection = newsapi.get_everything(q: params[:search_term], langage: 'en')
    preprocess_articles(news_collection)
    render json: news_collection
  end

  # def get_related_articles
  # end


  private

  def preprocess articles, user = nil
    articles.map! do |article|
      if validated?(article)
        art_obj = Article.new(
          id: SecureRandom.uuid,
          source: article.name,
          title: article.title,
          body: article.description,
          url: article.url,
          urlToImage: article.urlToImage,
          publication_date: article.publishedAt,
        )
        @@articles_cache << art_obj
        art_obj
      end
    end.compact!
  end

  def validated? article
    if params[:user_id]
      @user = User.find_by_id(params[:user_id])
      return article.description && !(@user.articles.any? { |art_obj| art_obj.url == article.url} )
    end
    true
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
