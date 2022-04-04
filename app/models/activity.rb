class Activity < ApplicationRecord
  has_one_attached :image
  belongs_to :customer
  has_many :favorites, dependent: :destroy
end
