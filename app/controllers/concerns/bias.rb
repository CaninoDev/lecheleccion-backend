module Bias
  def get_bias(article)
    Indico.api_key = Rails.application.credentials.indico[:api_key]
    Indico.political(sanitize(article.text))
    # text_tools = Aylien::TextAnalysis.new
    # classifications = text_tools.classify(article)
    # sanitized_text = sanitize(article.text)
    # sanitized_title = sanitize(article.title)
    # textObject = [sanitized_title, sanitized_text]
    # political_bias_tool(textObject)
    # sentimentality = text_tools.sentiment(mode: 'document', text: sanitized_text.gsub("\n", '') )
  end

  def political_bias_tool sanitized_text
    if sanitized_text.length > 400 && sanitized_text < 4000
      options = {
        body: {
          title: sanitized_title,
          text: sanitized_text
        }
      }
      response = HTTParty.post('https://topbottomcenter.com/api/', options)
    end
    response
  end

  def sanitize text
    ActionController::Base.helpers.sanitize(text)
  end
end