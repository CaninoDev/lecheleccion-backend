class AddUuidToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :uuid, :string
  end
end
