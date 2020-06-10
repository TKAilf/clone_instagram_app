class NotificationsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @followers = current_user.followers.paginate(page: params[:page])
    @checked_followers = current_user.passive_relationships
    #@notificationの中でまだ確認していない通知のみ
    @checked_followers.where(checked: false).each do |checked_follower|
      checked_follower.update_attributes(checked: true)
    end
  end
  
  def destroy_all
    @notifications = current_user.followers.destroy_all
    redirect_to notifications_path
  end
  
end
