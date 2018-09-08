class Bias < ApplicationRecord
  belongs_to :biasable, polymorphic: true
end
