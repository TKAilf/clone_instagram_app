class CommentsController < ApplicationController
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    #投稿に紐づいたコメントを作成
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment_micropost = @comment.micropost
    if @comment.save
      #通知の作成
      @comment_micropost.create_notification_comment!(current_user, @comment.id)
      render :index
    end
  end
  
end
