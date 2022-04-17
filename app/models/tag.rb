class Tag < ApplicationRecord
  has_many :team_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :teams, through: :team_tags

end