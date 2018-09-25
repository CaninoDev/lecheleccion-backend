# frozen_string_literal: true

class ArticlesChannel < ApplicationCable::Channel
  def recent (_data = nil)

    if 1 === 1
      articles = Article.last(10)
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

  def subscribed
    stream_from 'articles_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
