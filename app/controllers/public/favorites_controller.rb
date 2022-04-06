class Public::FavoritesController < ApplicationController
  def create
    @activity = Activity.find(params[:activity_id])
    favorite = current_customer.favorites.new(activity_id: @activity.id)
    favorite.save
  end

  def destroy
    @activity = Activity.find(params[:activity_id])
    favorite = current_customer.favorites.find_by(activity_id: @activity.id)
    favorite.destroy
  end
end
