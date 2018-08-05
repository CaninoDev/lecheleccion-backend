class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :url
      t.string :source
      t.datetime :publication_date
      t.string :title
      t.text :body
      t.decimal :bias

      t.timestamps
    end
  end
end
