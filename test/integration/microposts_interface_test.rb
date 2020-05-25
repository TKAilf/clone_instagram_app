require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get static_pages_home_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/instagram.jpg', 'image/jpg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content,
                                                   picture: picture } }
    end
    assert_redirected_to static_pages_home_path
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: '削除', count: 0
  end
  
end
