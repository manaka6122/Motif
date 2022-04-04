class Tag < ApplicationRecord
  has_many :team_tag, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :team_tags
end
