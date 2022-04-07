class Public::RoomsController < ApplicationController
  def index
    @customer_rooms = current_customer.customer_rooms
    myRoomIds = []
    @customer_rooms.each do |customer_room|
      myRoomIds << customer_room.room.id
    end
    @another_cusotomer_rooms = CustomerRoom.where(room_id: myRoomIds).where('customer_id != ?', customer.id)
  end
end
