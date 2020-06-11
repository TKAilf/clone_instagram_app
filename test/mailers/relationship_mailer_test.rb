require 'test_helper'

class RelationshipMailerTest < ActionMailer::TestCase
  
  test "follower_notification" do
    user = users(:michael)
    follower = users(:archer)
    mail = RelationshipMailer.follow_notification(user, follower)
    assert_equal "#{follower.name} following you", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.text_part.body.to_s.encode("UTF-8")
    assert_match follower.name, mail.text_part.body.to_s.encode("UTF-8")
  end
  
  test "unfollow_notification" do
    user = users(:michael)
    follower = users(:lana)
    mail = RelationshipMailer.unfollow_notification(user, follower)
    assert_equal "#{follower.name} unfollowed you", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.text_part.body.to_s.encode("UTF-8")
    assert_match follower.name, mail.text_part.body.to_s.encode("UTF-8")
  end
  
end
