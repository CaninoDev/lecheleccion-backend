require 'securerandom'
require 'pp'
class API::ArticlesController < ApplicationController

  @@articles_cache = []
  @@news_collector = Thirdpartyapi::Helper.init_news_collector
  @@news_collector_plus = Thirdpartyapi::Helper.news_analysis_interface
  @@text_analysis_interface = Thirdpartyapi::Helper.text_analysis_interface
  @@selected_codes = Thirdpartyapi::Helper.select_iptc_subjectcodes
  # @text_analysis = Thirdpartyapi.init_AylienText


  def index
    news_collection = collect_news
    preprocess(news_collection)
    pp news_collection.length
    render json: news_collection
  end

  def create
    article = @articles_cache.find_by_id(params[:article_id])
    postprocess(article)
    render json: article
  end

  def search
    news_collection = @news_collector.get_everything(q: params[:search_term], langage: 'en')
    preprocess(news_collection)
    render json: news_collection
  end

  # def get_related_articles
  # end

  private

  def collect_news (query = nil)
    collection = []
    if query === nil
      @@news_collector_plus.list_stories(Thirdpartyapi::Helper.aylien_news_options).stories.each {|article| collection << article}
      @@news_collector.get_top_headlines(country: 'us', pageSize: 50).each {|article| collection << article}
    end
    # preprocess(collection)
  end

  def preprocess articles
    articles.map! do |article|
      pp article
      pp article.url
      art_obj = Hash.new(nil)
        art_obj[:id] = SecureRandom.uuid
        art_obj[:title] = article.title
        case article
          when AylienNewsApi::Story
            art_obj[:source] = article.source.name
            art_obj[:body] = article.body
            art_obj[:url] = article.links.permalink
            art_obj[:urlToImage] = article.media[0].url
            art_obj[:publication_date] = article.published_at
          when Everything
            body = @@text_analysis_interface.extract(url: article.url)
            art_obj[:source] = article.name
            art_obj[:body] = (body ? body : '')
            art_obj[:url] = article.url
            art_obj[:urlToImage] = article.urlToImage
            art_obj[:publication_date] = article.publishedAt
        end
        if validated?(art_obj)
          art_obj
        end
      end
    end


  def validated? article
    if params[:user_id] != nil
      user_obj = User.find_by_id(params[:user_id])
      if (user_obj.articles.any? { |art_obj| art_obj.url == article.url})
        return false
      end
    end
    # classes = @@text_analysis_interface.classify(url: article[:url])
    # classes[:categories].each do |category|
    #   if @@selected_codes.any? { |code| code == category[:code] } then
    #     return true
    #   end
    # end
    true
  end

  def postprocess article
    article.body = @@text_analysis_interface.extract(url: article.url)[:article]
    article.bias = get_article_bias(article.body)
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
