class Public::TeamsController < ApplicationController
  before_action :set_team, only: [:show, :destroy, :edit, :update]
  before_action :authenticate_customer!, except: [:index, :show]
  before_action :ensure_customer, only: [:edit, :update, :destroy]

  def new
    @team = Team.new
  end

  def create
    @team = current_customer.teams.new(team_params)
    tag_list = params[:team][:tag_name].split(',')
    if @team.save
      @team.save_tags(tag_list)
      redirect_to team_path(@team)
      flash[:notice] = "楽団情報を登録しました。"
    else
      render :new
    end
  end

  def index
    @tag_list = Tag.all
    @teams = Team.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def update
    tag_list = params[:team][:tag_name].split(',')
    if @team.update(team_params)
      @team.save_tags(tag_list)
      redirect_to team_path(@team)
      flash[:notice] = "楽団情報の更新が完了しました。"
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path
  end

  private

  def team_params
    params.require(:team).permit(:name, :address, :introduction)
  end

  def set_team
    @team = Team.find(params[:id])
  end
  
  def ensure_customer
    @teams = current_customer.teams
    @team = @teams.find_by(id: params[:id])
    redirect_to new_activity_path unless @team
  end
end
