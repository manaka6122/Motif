class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :room
  validates :customer_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }
end
