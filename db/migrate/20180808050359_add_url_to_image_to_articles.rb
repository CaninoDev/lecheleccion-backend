class AddUrlToImageToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :urlToImage, :string
  end
end
