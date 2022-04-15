class Public::HomesController < ApplicationController
  def top
    @activities = Activity.where(status: 0)
  end

  def about
  end
end
