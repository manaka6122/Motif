class Public::RoomsController < ApplicationController

  def index
    @customer_rooms = current_customer.customer_rooms
    my_room_ids = []
    @customer_rooms.each do |customer_room|
      my_room_ids << customer_room.room.id
    end
    @another_customer_rooms = CustomerRoom.where(room_id: my_room_ids).where('customer_id != ?', @customer_rooms.ids)
  end

end