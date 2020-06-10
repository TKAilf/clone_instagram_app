class LikesController < ApplicationController
  
  def create
    like = current_user.likes.new(micropost_id: @micropost.id)
    like.save
    @micropost = Micropost.find(params[:micropost_id])
    #通知の作成
    @micropost.create_notification_by(current_user)
    respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
    end
  end

end
