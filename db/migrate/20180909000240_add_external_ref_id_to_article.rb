class AddExternalRefIdToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :external_reference_id, :integer
  end
end
