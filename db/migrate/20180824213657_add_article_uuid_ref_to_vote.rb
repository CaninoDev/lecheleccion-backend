class AddArticleUuidRefToVote < ActiveRecord::Migration[5.2]
  def change
    add_reference :votes, :article_uuid, foreign_key: true
  end
end
