class RemoveArticleRefFromVote < ActiveRecord::Migration[5.2]
  def change
    remove_reference :votes, :article_id, foreign_key: true
  end
end
