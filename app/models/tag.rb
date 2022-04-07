class Tag < ApplicationRecord
  has_many :team_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :teams, through: :team_tags

  def self.search_teams_for(content, method)
    if method == 'perfect'
      tags = Tag.where(name: content)
    elsif method == 'forward'
      tags = Tag.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      tags = Tag.where('name LIKE ?', '%' + content)
    else
      tags = Tag.where('name LIKE ?', '%' + content + '%')
    end

    return tags.inject(init = []) {|result, tag|  result + tag.teams}
  end
end
