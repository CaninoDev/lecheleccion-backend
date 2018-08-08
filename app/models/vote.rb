class Vote < ApplicationRecord
  belongs_to :id_user
  belongs_to :id_article
end
