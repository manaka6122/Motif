class Public::CustomersController < ApplicationController
  def show
    @customer = Customer.find(params[:id])
    @teams = @customer.teams
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to customer_path(@customer)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :profile, :profile_image)
  end

end
