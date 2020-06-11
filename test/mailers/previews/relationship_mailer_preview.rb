# Preview all emails at https://a535dc97ee13464e95ae8d648bd95ed9.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/relationship_mailer
class RelationshipMailerPreview < ActionMailer::Preview
  
  # Preview this email at https://a535dc97ee13464e95ae8d648bd95ed9.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/relationship_mailer/follow_notification
  def follow_notification
    user = User.first
    follower = User.second
    RelationshipMailer.follow_notification(user, follower)
  end

  # Preview this email at https://a535dc97ee13464e95ae8d648bd95ed9.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/relationship_mailer/unfollow_notification
  def unfollow_notification
    user = User.first
    follower = User.second
    RelationshipMailer.unfollow_notification(user, follower)
  end

end
