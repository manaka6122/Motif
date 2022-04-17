class Activity < ApplicationRecord
  belongs_to :customer
  belongs_to :team
  has_many :favorites, dependent: :destroy

  has_one_attached :image

  validates :title, presence:true
  validates :content, presence:true, length:{maximum:200}
  validates :status, presence:true
  validates :activity_on, presence:true

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

  enum status: {disclose: 0, undisclosed: 1}
end
