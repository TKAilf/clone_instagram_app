class FacebooksController < ApplicationController
  include SessionsHelper
  
  def new
  end
  
  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      @user = User.find_or_create_user_from_auth(auth)
      log_in(@user)
      @user.update_attributes(activated: true, activated_at: Time.zone.now, unique_name: @user.uid)
      flash[:success] = "facebookアカウントでログインできました!"
      redirect_to static_pages_home_path
    else
      flash.now[:danger] = "facebookアカウントが見つかりません"
      render root_url
    end
  end
end
