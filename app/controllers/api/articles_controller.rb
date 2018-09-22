# frozen_string_literal: true

require 'pp'
# API endpoints for the collection and distribution of select news articles
class API::ArticlesController < ApplicationController
  def index
    cursor = nil
    2.times do
      news_collection = Vendor.get_news_articles(cursor: cursor)
      cursor = news_collection.next_page_cursor
      preprocess(news_collection)
    end
  end

  def search
    news_collection = Vendor.get_news_articles params[:search_term]
    processed = preprocess(news_collection)
    json_response(processed)
  end

  def bias
    articles_average = Article.averages
    render json: articles_average
  end

  private

  def preprocess(articles)
    prefiltered_articles = prefilter(articles)
    prefiltered_articles.each do |article|
      create_article_record(article)
    end
  end

  def create_article_record(article)
    article_record = Article.new(
      :title => article.title,
      :source => article.source.name,
      :body => article.body,
      :url => article.links.permalink,
      :urlToImage => article.media[0].url,
      :publication_date => article.published_at,
      :external_reference_id => article.id
    )
    if article_record.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        ArticleSerializer.new(article_record)
      ).serializable_hash
      ActionCable.server.broadcast 'articles_channel', serialized_data
      head :ok
    end
  end

  def prefilter(articles)
    articles.stories.reject { |article| article.body.length < 400 || article.title.empty? }
  end

  def article_params
    params.permit(:search_terms, :number_of_articles)
  end
end
