class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :url, :urlToImage, :source, :publication_date, :title, :body
  has_one :bias, as: :biasable
end
