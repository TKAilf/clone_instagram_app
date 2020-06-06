class NotificationsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @notifications = current_user.passive_relationships.paginate(page: params[:page])
  end
  
  def update
    
  end
  
  def destroy_all
    @notifications = current_user.passive_relationships.destroy_all
    redirect_to notifications_path
  end
  
end
