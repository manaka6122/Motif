class Public::RoomsController < ApplicationController

  def index
    @customer_rooms = current_customer.customer_rooms
    my_room_ids = []
    @customer_rooms.each do |customer_room|
      my_room_ids << customer_room.room.id
    end
    @another_customer_rooms = CustomerRoom.where(room_id: my_room_ids).where.not(customer_id: current_customer.id).page(params[:page]).per(10)
  end

end