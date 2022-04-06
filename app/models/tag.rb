class Tag < ApplicationRecord
  has_many :team_tag, dependent: :destroy, foreign_key: 'tag_id'
  has_many :team, through: :team_tags
end
