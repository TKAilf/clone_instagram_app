module SessionsHelper
  
  #渡されたユーザーで一時的にログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #現在ログインしているユーザーを返す
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  #ユーザーがログインしていればtrue,していなければfalseを返す
  def logged_in?(user)
    !current_user.nil?
  end
  
  def logout
    session.delete(:user_id)
    @current_user = nil
  end
  
end
