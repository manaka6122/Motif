class Room < ApplicationRecord
  has_many :messages
  has_many :customer_rooms
  has_many :notifications, dependent: :destroy

  def create_notification_dm(current_customer, message_id)
    @all_room_member = CustomerRoom.where(room_id: id).where.not(customer_id: current_customer.id)
    @first_room_member = @all_room_member.find_by(room_id: id)
    notification = current_customer.active_notifications.build(
      room_id: id,
      message_id: message_id,
      visited_id: @first_room_member.customer_id,
      action: 'dm'
    )
    if notification.visitor_id == notification.visited_id
        notification.checked = true
    end
    notification.save if notification.valid?
  end
end
