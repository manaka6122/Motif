class Admin::ActivitiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = Activity.all
  end

  def show
  end

  def edit
  end

  def update
    if @activity.update(activity_params)
      redirect_to admin_activity_path(@activity)
      flash[:notice] = '活動情報の更新が完了しました。'
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to admin_activities_path
  end

  private

  def activity_params
    params.require(:activity).permit(:image, :title, :content, :team_id, :activity_on, :status)
  end

  def ensure_activity
    @activity = Activity.find(params[:id])
  end
end
