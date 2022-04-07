class Public::TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = current_customer.teams.new(team_params)
    tag_list = params[:team][:tag_name].split(nil)
    if @team.save
      @team.save_tags(tag_list)
      redirect_to team_path(@team)
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
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update(team_params)
    redirect_to team_path(@team)
  end

  def destroy
    @team = Team.find(params[:id])
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
end
