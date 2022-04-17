class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
    @teams = @customer.teams.page(params[:page])
    @activities = @customer.activities.page(params[:page]).per(10)
  end
end
