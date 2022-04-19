class Public::ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :destroy, :edit, :update]
  before_action :authenticate_customer!, except: [:index, :show]

  def new
    @activity = Activity.new
  end

  def create
    @activity = current_customer.activities.new(activity_params)
    if @activity.save
      redirect_to activity_path(@activity)
      flash[:notice] = "活動情報を投稿しました。"
    else
      render :new
    end
  end

  def index
    @activities = Activity.where(status: 0).page(params[:page]).per(6)
  end

  def show
  end

  def destroy
    @activity.destroy
    redirect_to activities_path
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    if @activity.update(activity_params)
      redirect_to activity_path(@activity)
      flash[:notice] = "活動情報の更新が完了しました。"
    else
      render :edit
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:image, :title, :content, :team_id, :activity_on, :status)
  end

  def set_activity
     @activity = Activity.find(params[:id])
  end
end
