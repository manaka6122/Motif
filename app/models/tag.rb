class Tag < ApplicationRecord
  has_many :team_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :teams, through: :team_tags

  def self.search_teams_for(content)
    tags = Tag.where('name LIKE(?)', '%' + content + '%')
    tags.inject(init = []) {|result, tag|  result + tag.teams}
  end
end