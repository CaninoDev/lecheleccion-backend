# frozen_string_literal: true

class ArticlesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'articles_channel'
  end

  def recent(_data = nil)
    if Article.last.created_at.between?(Time.zone.now.ago(2.hours), Time.zone.now)
      articles = Article.last(50)
      articles.each do |article|
        ActionCable
            .server
            .broadcast('articles_channel',
                       article)
      end
    else
      ArticleProcessor.fetch_an_render_news_articles
    end
  end



  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
