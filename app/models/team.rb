class Team < ApplicationRecord
  belongs_to :customer
  has_many :activities
  has_many :team_tags, dependent: :destroy
  has_many :tags, through: :tag_maps
end
