# frozen_string_literal: true

# Websocket for transmitting article datar
class ArticlesChannel < ApplicationCable::Channel
  def recent (_data = nil)

    if (Article.count < 1 || Article.last.created_at < Time.zone.now.ago(2.hours))
      ArticleProcessor.fetch_and_render_news_articles
    else
      articles = Article.last(10)
      articles.each do |article|
        ActionCable
          .server
          .broadcast('articles_channel',
                     article)
      end
    end
  end

  def subscribed
    stream_from 'articles_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
