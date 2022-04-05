class Public::TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = current_customer.teams.new(team_params)
    @team.save
    redirect_to teams_path
  end

  def index
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

  private

  def team_params
    params.require(:team).permit(:name, :address, :introduction)
  end
end
