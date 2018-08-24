class RemoveArticleIdFromVote < ActiveRecord::Migration[5.2]
  def change
    remove_column :votes, :article_id, :integer
  end
end
