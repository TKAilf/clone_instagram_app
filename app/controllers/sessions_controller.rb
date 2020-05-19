class SessionsController < ApplicationController
  
  def new
    @user
  end
  
  def create
    @user = User.find_by(email: params[:sessions][:email].downcase)
    if @user && @user.authenticate(params[:sessions][:password])
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = "メールアドレスかパスワードが違います。"
      render 'new'
    end
  end
  
  def destroy
  end
  
end
