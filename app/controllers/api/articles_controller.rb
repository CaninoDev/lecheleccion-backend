class API::ArticlesController < ApplicationController
  def index
  end

  def create
  end

  def show
  end

  def fetchNews
    newsapi = News.new(Rails.application.credentials.googlenews[:api_key])
    top_headlines = newsapi.get_top_headlines(
      category: 'politics',
      language: 'en',
      country: 'us'
      )
    json_response(top_headlines)
  end

end
