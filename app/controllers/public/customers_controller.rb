class Public::CustomersController < ApplicationController
  before_action :set_current_customer
  before_action :guest_user, only: [:edit]

  def show
    @teams = @customer.teams.page(params[:page])
    @activities = @customer.activities.page(params[:page]).per(6)
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customer_path(@customer)
      flash[:notice] = '会員情報の更新が完了しました。'
    else
      render :show
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :profile, :profile_image)
  end

  def set_current_customer
    @customer = Customer.find(params[:id])
  end

  def guest_user
    if @customer.name == "guestuser"
      redirect_to customer_path(current_customer)
      flash[:notice] = 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

end
