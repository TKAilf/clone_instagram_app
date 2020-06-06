class User < ApplicationRecord
  
  attr_accessor :remember_token, :activation_token, :reset_token
  # @一意ユーザ名の正規表現(大文字小文字を区別しない、半角英数とアンダースコアのみ)
  before_save :downcase_unique_name
  before_save :downcase_email, unless: :uid?
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  VALID_UNIQUE_NAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :unique_name, presence: true, length: { maximum: 50 },
                          format: { with: VALID_UNIQUE_NAME_REGEX },
                          uniqueness: { case_sensitive: false }
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  #渡されたstring引数に対してハッシュを返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークン(乱数)を返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたリメンバートークンがリメンバーダイジェストと同等の場合trueを返す
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # メールアドレスを小文字化させる
  def downcase_email
    self.email = email.downcase
  end
  
  # activationトークンとダイジェストをそれぞれ作成し、インスタンス変数に代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
  # アカウントを有効化する
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定用の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # パスワード再設定用のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワードリセット用リンクの有効期限時間が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                    OR user_id = :user_id
                    OR in_reply_to =   :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
    if notification == true
      Relationship.send_follow_email(other_user, self)
      create_notification_follow(self)
    end
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
    Relationship.send_unfollow_email(other_user, self)
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # oauth-facebookで取り出した情報を各ユーザー毎に検索、なければ作成する
  def self.find_or_create_user_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    name = auth[:info][:name]
    image = auth[:info][:image]
    email = auth[:info][:email]
    password = SecureRandom.urlsafe_base64
    
    user = self.where(uid: auth.uid, provider: auth.provider).first
    
    unless user
      user = self.create(
        uid:        uid,
        provider:   provider,
        email:      email,
        name:       name,
        password:   password,
        image_url:  image,
        unique_name: uid
      )
    end
    
    user
  end

  # 一意ユーザ名をすべて小文字にする
  def downcase_unique_name
    self.unique_name.downcase!
  end
  
  private
    # フォロー時の通知
    def create_notification_follow(current_user)
      temp = Relationship.where(["follower_id = ? and followed_id = ? ",current_user.id, id])
      if temp.blank?
        notification = current_user.active_relationships.new(followed_id: id)
        notification.save if notification.valid?
      end
    end

end
