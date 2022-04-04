class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  has_one_attached :profile_image

  has_many :teams, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :messages
end
