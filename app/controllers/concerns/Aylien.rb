module Aylien
  class TextAnalysisHelper

    def self.init
      AylienTextApi.configure do |config|
        config.app_id        =    Rails.application.credentials.aylien_text_api[:app_id]
        config.app_key       =    Rails.application.credentials.aylien_text_api[:api_key]
      end
      AylienTextApi::Client.new
    end
  end

  class NewsApi
  # Using the following IPTC categories for conducting search:
  #  11000000 => Politics
  #  11003005 => regional elections
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
  #  04008005 => emergin market

  # See https://iptc.org/standards/subject-codes/
    Options = Struct.new(
      :categories_taxonomy,
      :categories_id,
      :text,
      :published_at_start,
      :published_at_end
    )

    def initialize
      AylienNewsApi.configure do |config|
        config.api_key['X-Aylien-NewsAPI-Application-ID'] = Rails.application.credentials.aylien_news_api[:app_id]
        config.api_key['X-Aylien-NewsAPI-Application-key'] = Rails.application.credentials.aylien_news_api[:api_key]
      end
      AylienNewsApi::DefaultApi.new
    end
  end
end
