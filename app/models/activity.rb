class Activity < ApplicationRecord
  belongs_to :customer
  belongs_to :team
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :image

  validates :title, presence:true
  validates :content, presence:true, length:{maximum:200}
  validates :status, presence:true
  validates :activity_on, presence:true

  enum status: {disclose: 0, undisclosed: 1}

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

  def create_notification_favorite(current_customer)
    # すでに「いいね」されているか検索
    favorited = Notification.where(["visitor_id = ? and visited_id = ? and activity_id = ? and action = ? ", current_customer.id, customer_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if favorited.blank?
      notification = current_customer.active_notifications.new(
        activity_id: id,
        visited_id: customer_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
