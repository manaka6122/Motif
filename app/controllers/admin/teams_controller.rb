class Admin::TeamsController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_team, only: [:show, :edit, :update, :destroy]

  def index
    @teams = Team.all
  end

  def show
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to admin_team_path(@team)
      flash[:notice] = '楽団情報がの更新が完了しました。'
    else
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to team_path(@team)
  end

  private

  def team_params
    params.require(:team).permit(:name, :address, :introduction)
  end

  def ensure_team
    @team = Team.find(params[:id])
  end

end
