class NotificationsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @notifications = current_user.followers.paginate(page: params[:page])
  end
  
  def destroy_all
    @notifications = current_user.followers.destroy_all
    redirect_to notifications_path
  end
  
end
