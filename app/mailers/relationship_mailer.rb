class RelationshipMailer < ApplicationMailer
  
  # フォロー時の通知
  def follow_notification(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: "#{follower.name} following you"
  end
  
  # フォロー解除時の通知
  def unfollow_notification(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: "#{@follower.name} unfollowed you"
  end
  
end
