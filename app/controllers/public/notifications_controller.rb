class Public::NotificationsController < ApplicationController

  def index
    @notifications = current_customer.passive_notifications.page(params[:page]).per(15)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy
    @notifications = current_customer.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
