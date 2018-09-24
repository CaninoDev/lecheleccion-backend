class ArticlesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'articles_channel'
  end

  def recent(data = nil)
    articles = Article.last(10)
    articles.each do |article|
      ActionCable
          .server
          .broadcast('articles_channel',
                     article
          )
      end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
