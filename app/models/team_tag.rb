class TeamTag < ApplicationRecord
  belongs_to :team
  belongs_to :tag
　
  validates :team_id, presence: true
  validates :tag_id, presence: true
end
