class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_favorite

  def create
    favorite = current_customer.favorites.new(activity_id: @activity.id)
    favorite.save
    @activity.create_notification_favorite(current_customer)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    favorite = current_customer.favorites.find_by(activity_id: @activity.id)
    favorite.destroy
  end

  private

  def set_favorite
    @activity = Activity.find(params[:activity_id])
  end
end
