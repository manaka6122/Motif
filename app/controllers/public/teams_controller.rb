class Public::TeamsController < ApplicationController
  before_action :set_team, only: [:show, :destroy, :edit, :update]

  def new
    @team = Team.new
  end

  def create
    @team = current_customer.teams.new(team_params)
    tag_list = params[:team][:tag_name].split(',')
    if @team.save
      @team.save_tags(tag_list)
      redirect_to team_path(@team)
      flash[:notice] = '楽団情報を登録しました。'
    else
      @teams = Team.all
      render 'index'
    end
  end

  def index
    @tag_list = Tag.all
    @teams = Team.all
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
      flash[:notice] = '楽団情報の更新が完了しました。'
    else
      render :show
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path
  end

  def search
     @tag_list = Tag.all
     @tag = Tag.find(params[:tag_id])
     @teams = @tag.team.all
  end

  private

  def team_params
    params.require(:team).permit(:name, :address, :introduction)
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
