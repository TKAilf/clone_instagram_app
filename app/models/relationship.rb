class Relationship < ApplicationRecord
  
  #スコープ(新着順)
  default_scope->{order(created_at: :desc)}
  belongs_to :follower, class_name: "User", foreign_key: 'follower_id', optional: true
  belongs_to :followed, class_name: "User", foreign_key: 'followed_id', optional: true
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  belongs_to :micropost, optional: true
  belongs_to :comment, optional: true
  
  def Relationship.send_follow_email(user, follower)
    RelationshipMailer.follow_notification(user, follower).deliver_now
  end
  
  def Relationship.send_unfollow_email(user, follower)
    RelationshipMailer.unfollow_notification(user, follower).deliver_now
  end
  
  def create_notification_by(current_user)
        notification = current_user.active_relationships.new(
          micropost_id: id,
          followed_id: user_id,
          action: "like"
        )
        notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
          save_notification_comment!(current_user, comment_id, temp_id['user_id'])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, followed_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    relationship = current_user.active_relationships.new(
      micropost_id: id,
      comment_id: comment_id,
      followed_id: followed_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if relationship.follower_id == relationship.followed_id
      relationship.checked = true
    end
    relationship.save if relationship.valid?
  end
  
end
