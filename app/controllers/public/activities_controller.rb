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
    @activities_all = Activity.all
    @activities = Activity.where(status: 0)
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    redirect_to activities_path
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    @activity.update(activity_params)
    redirect_to activity_path
  end

  private

  def activity_params
    params.require(:activity).permit(:image, :title, :content, :team_id, :activity_on, :status)
  end
end
