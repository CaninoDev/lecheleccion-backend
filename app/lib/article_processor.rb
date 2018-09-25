# frozen_string_literal: true

# Processor module culled originally from ArticlesController
module ArticleProcessor
  include Vendor
  def self.fetch_and_render_news_articles
    news_collection = Vendor.get_news_articles(number: 50)
    process_and_render(news_collection)
  end

  def self.process_and_render(articles)
    prefiltered_articles = pre_filter(articles)
    prefiltered_articles.each do |article|
      create_article_record(article)
    end
  end

  def self.create_article_record(article)
    article_record = Article.create(
      title: article.title,
      source: article.source.name,
      body: article.body,
      url: article.links.permalink,
      urlToImage: article.media[0].url,
      publication_date: article.published_at,
      external_reference_id: article.id
    )
    ActionCable
        .server
        .broadcast('articles_channel',
                   article_record)
  end

  def self.pre_filter(articles)
    articles.stories.reject { |article| article.body.length < 400 || article.title.empty? }
  end
end
