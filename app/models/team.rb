class Team < ApplicationRecord
  belongs_to :customer
  has_many :activities
  has_many :team_tags, dependent: :destroy
  has_many :tags, through: :team_tags

  validates :name, presence:true
  validates :address, presence:true
  validates :introduction, presence:true, length:{maximum:200}

  def save_tags(sent_tags)
     # 現在のユーザーの持っているtagを引っ張ってきている
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 今bookが持っているタグと今回保存されたものの差をすでにあるタグとする。古いタグは消す。
    old_tags = current_tags - sent_tags
    # 今回保存されたものと現在の差を新しいタグとする。新しいタグは保存
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name:old)
    end

    new_tags.each do |new|
      team_tag = Tag.find_or_create_by(name:new)
      self.tags << team_tag
    end
  end

  def self.search_for(content)
    if content != ""
      Team.where(['name LIKE(?) OR address LIKE(?)', "%#{content}%", "%#{content}%"])
    else
      Team.all
    end
  end

  def self.search_from_tags(content)
    result = Team.all
    if content != ""
      result = result.joins(:tags).where('tags.name LIKE(?)', '%' + content + '%')
    end
  end

end
