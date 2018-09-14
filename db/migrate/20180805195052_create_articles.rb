class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :url
      t.string :urlToImage
      t.string :source
      t.datetime :publication_date
      t.string :title
      t.text :body
      t.integer :external_reference_id
      t.timestamps
    end
  end
end
