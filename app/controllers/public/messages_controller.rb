class Public::MessagesController < ApplicationController
  before_action :authenticate_customer!


  def show
    @customer = Customer.find(params[:id])
    rooms = current_customer.customer_rooms.pluck(:room_id)
    customer_rooms = CustomerRoom.find_by(customer_id: @customer.id, room_id: rooms)

    unless customer_rooms.nil?
      @room = customer_rooms.room
    else
      @room = Room.new
      @room.save
      CustomerRoom.create(customer_id: current_customer.id, room_id: @room.id)
      CustomerRoom.create(customer_id: @customer.id, room_id: @room.id)
    end

    @messages = @room.messages
    @message = Message.new(room_id: @room.id)
  end

  def create
    @message = current_customer.messages.new(message_params)
    @message.save
    @room = Room.find(@message.room.id)
    @messages = @room.messages
    @message_room = @message.room
    @message_room.create_notification_dm(current_customer, @message.id)
    @customer = @room.customer_rooms.where.not(customer: current_customer).first.customer
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
