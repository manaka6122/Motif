class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :room
  has_many :notifications, dependent: :destroy

  validates :customer_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  
end
