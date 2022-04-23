class Public::CustomersController < ApplicationController
  before_action :set_current_customer
  before_action :guest_user, only: [:edit]
  before_action :authenticate_customer!, except: [:show]

  def show
    @teams = @customer.teams.page(params[:page])
    @activities = @customer.activities.page(params[:page]).per(6)
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customer_path(@customer)
      flash[:notice] = "会員情報の更新が完了しました。"
    else
      render :edit
    end
  end

  def favorites
    favorites = Favorite.where(customer_id: @customer.id).pluck(:activity_id)
    @favorite_activities = Activity.find(favorites)
    @favorite_activities = Kaminari.paginate_array(@favorite_activities).page(params[:page]).per(6)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :profile, :profile_image)
  end

  def set_current_customer
    @customer = Customer.find(params[:id])
  end

  def guest_user
    @customer = Customer.find(params[:id])
    if @customer.name == "guestuser"
      redirect_to customer_path(current_customer)
      flash[:notice] = "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
