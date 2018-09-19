# Third party module for initialiasing connections and interfacign with their assets
module Vendor
  attr_accessor :google_news_api, :aylien_news_api, :aylien_text_api, :iptc_subject_codes

  def self.included mod
    init_subject_codes
    init_aylien_text
    init_aylien_news
    init_indico
    @google_news_api = News.new(Rails.application.credentials.googlenews[:api_key])
    @aylien_news_api = AylienNewsApi::DefaultApi.new
    @aylien_text_api = AylienTextApi::Client.new
    puts '3rd party API intialized'
  end

  def self.init_aylien_text
    AylienTextApi.configure do |config|
      config.app_id        =    Rails.application.credentials.aylien_text_api[:app_id]
      config.app_key       =    Rails.application.credentials.aylien_text_api[:api_key]
    end
  end

  def self.init_aylien_news
    AylienNewsApi.configure do |config|
      config.api_key['X-AYLIEN-NewsAPI-Application-ID'] = Rails.application.credentials.aylien_news_api[:app_id]
      config.api_key['X-AYLIEN-NewsAPI-Application-Key'] = Rails.application.credentials.aylien_news_api[:api_key]
    end
  end

  def self.init_indico
    Indico.api_key = Rails.application.credentials.indico[:api_key]
  end

  def self.select_iptc_subjectcodes
    @iptc_subject_codes = ['11000000','16000000','14000000','02000000','04000000','05000000','06000000','06004000','07011000','07013000','11024000','11024001','11005001','06004000','11006001','11006012','16003003','11002002','11009000','09004000','11023000','04008005','11003000','16003002']
  end

  def self.aylien_news_options
    read_article = Article.all.map {|art| art[:external_reference_id].to_s}
    options = {
    not_id: read_article.last(200),
    language: ['en'],
    published_at_start: 'NOW-2DAYS',
    published_at_end: 'NOW',
    categories_taxonomy: 'iptc-subjectcode',
    categories_confident: true,
    categories_id: @iptc_subject_codes,
    source_rankings_alexa_rank_min: 3,
    source_rankings_alexa_rank_max: 500,
    media_images_count_min: 1,
    per_page: 50
    }
    options
  end

  def self.get_news_articles query=nil
    options = aylien_news_options
    if !query.nil?
      options[:text] = query
    end
    @aylien_news_api.list_stories(options)
  end

  def self.get_text_bias article_body
    Indico.political(article_body)
  end
end


# using the following IPTC categories for conducting search
#  11000000 => Politics
#  16000000 => unrest, conflict, war
#  14000000 => social issue
#  02000000 => crime, law, and justice
#  04000000 => economy, business, and finance
#  05000000 => education
#  06000000 => environmental issues
#  06004000 => environemtal politics
#  07011000 => government and healthcare
#  07013000 => healthcare policy
#  11024000 => politics (general)
#  11024001 => political systems
#  11005001 => economic sanction
#  06004000 => environmental politics
#  11006001 => civil and public service
#  11006012 => nationalisation
#  16003003 => political dissent
#  11002002 => international relations
#  11009000 => parliament
#  09004000 => labour dispote
#  11023000 => censorship
#  04008005 => emerging market
#  11003000 => politics (election)
#  16003002 => civil unrest (rebellion)

# See https://iptc.org/standards/subject-codes/
# Options = Struct.new(
#   :language,
#   :published_at_start,
#   :published_at_end,
#   :categories_taxonomy,
#   :categories_confident,
#   :categories_id,
#   :source_rankings_alexa_rank_min,
#   :source_rankings_alexa_rank_max,
#   :media_images_count_min,
#   :per_page
# )
