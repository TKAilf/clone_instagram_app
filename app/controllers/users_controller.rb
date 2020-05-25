class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント有効化用のメールを送信しました。確認してください。"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to static_pages_home_path and return unless @user.activated?
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "更新に成功しました"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除できました!"
    redirect_to users_path
  end
  
  private
    
    #ストロングパラメーター
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #beforeアクション
    
    #ログイン済みであっても、正しいユーザーであるかの確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    
    #セキュリティーを確実にするためにadminがtrueかどうか調べる
    def admin_user
      redirect_to static_pages_home_path unless current_user.admin?
    end
  
end
