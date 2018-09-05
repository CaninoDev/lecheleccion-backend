  # AylienText::Information
  # Using the following IPTC categories for conducting search:
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
module Thirdpartyapi

  # Options = Struct.new(
  #   :categories_taxonomy,
  #   :categories_id,
  #   :text,
  #   :published_at_start,
  #   :published_at_end
  # )
  def self.included(mod)
    init_AylienText
    init_AylienNews
    init_Indico
    puts '3rd party API intialized'
  end


  def self.init_AylienText
    AylienTextApi.configure do |config|
      config.app_id        =    Rails.application.credentials.aylien_text_api[:app_id]
      config.app_key       =    Rails.application.credentials.aylien_text_api[:api_key]
    end
  end

  def self.init_AylienNews
AylienNewsApi.configure do |config|
      config.api_key["X-AYLIEN-NewsAPI-Application-ID"] = Rails.application.credentials.aylien_news_api[:app_id]
      config.api_key["X-AYLIEN-NewsAPI-Application-Key"] = Rails.application.credentials.aylien_news_api[:api_key]
    end
  end

  def self.init_Indico
    Indico.api_key = Rails.application.credentials.indico[:api_key]
  end

  class Helper
    def self.init_news_collector
      News.new(Rails.application.credentials.googlenews[:api_key])
    end

    def self.text_analysis_interface
      AylienTextApi::Client.new
    end

    def self.news_analysis_interface
      AylienNewsApi::DefaultApi.new
    end

    def self.bias_analysis_interface
      Indico
    end

    def self.select_iptc_subjectcodes
      [ '11000000','16000000','14000000','02000000','04000000','05000000','06000000','06004000','07011000','07013000','11024000','11024001','11005001','06004000','11006001','11006012','16003003','11002002','11009000','09004000','11023000','04008005','11003000','16003002']
    end

    def self.aylien_news_options
      {
        :language => ['en'],
        :published_at_start => 'NOW-2DAYS',
        :published_at_end => 'NOW',
        :categories_taxonomy => 'iptc-subjectcode',
        :categories_confident => true,
        :categories_id => self.select_iptc_subjectcodes,
        :source_rankings_alexa_rank_min => 3,
        :source_rankings_alexa_rank_max => 500,
        :media_images_count_min => 1,
        :per_page => 30
      }
    end
  end
end
