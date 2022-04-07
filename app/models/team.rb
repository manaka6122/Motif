class Team < ApplicationRecord
  belongs_to :customer
  has_many :activities
  has_many :team_tags, dependent: :destroy
  has_many :tags, through: :team_tags

  validates :name,presence:true
  validates :address,presence:true
  validates :introduction,presence:true,length:{maximum:200}

  def save_tags(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name:old)
    end

    new_tags.each do |new|
      team_tag = Tag.find_or_create_by(name:new)
      self.tags << team_tag
    end
  end

end
