class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
