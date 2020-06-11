class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    # @から始まり、半角英数またはアンダースコアが5回以上、20回以下の繰り返しにマッチ。大文字、小文字区別しない。
    reply_name = /@([0-9a-z_]{5,20})/i
    # 投稿文に対して上記正規表現をマッチング
    @micropost.content.match(reply_name)
    # $1は正規表現の中の丸かっこの表現にマッチする内容が入る(つまりここでは一意ユーザ名)
    # マッチするものが無ければnil
    if $1
      # マッチした一意ユーザ名は小文字にしてから検索します
      reply_user = User.find_by(unique_name: $1.downcase)
      # 一意ユーザ名を持つ返信先ユーザが存在すればin_reply_toカラムにそのユーザIDをセット
      @micropost.in_reply_to = reply_user.id if reply_user
    end
    
    if @micropost.save
      flash[:success] = "投稿できました!"
      redirect_to static_pages_home_path
    else
      @feed_items = []
      render static_pages_home_path
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to request.referrer || static_pages_home_path
  end
  
    private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to static_pages_home_path if @micropost.nil?
    end
  
end