class Public::ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def create
    @activity = current_customer.activities.new(activity_params)
    @activity.save
    redirect_to activities_path
  end

  def index
    @activities = Activity.all
  end

  def show
    @actibity = Activity.find(params[:id])
  end

  def edit
  end

  private

  def activity_params
    params.require(:activity).permit(:image, :title, :content, :team_id, :activity_on)
  end
end
