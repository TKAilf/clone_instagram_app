class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to static_pages_home_path
    else
      flash.now[:danger] = "メールアドレスかパスワードが違います。"
      render 'new'
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
  
end
