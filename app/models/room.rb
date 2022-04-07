class Room < ApplicationRecord
  has_many :messages
  has_many :customer_rooms
end
