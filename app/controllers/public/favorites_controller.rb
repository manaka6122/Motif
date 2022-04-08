class Public::FavoritesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_favorite

  def create
    favorite = current_customer.favorites.new(activity_id: @activity.id)
    favorite.save
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
