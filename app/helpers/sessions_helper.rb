module SessionsHelper
  
  #渡されたユーザーで一時的にログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #渡されたインスタンス変数に対して永続的にログインさせる
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #現在ログインしているユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  #ユーザーがログインしていればtrue,していなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  #永続的ログインを解除する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  #ログアウトする。その際に、永続的ログインも解除する。
  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
end
