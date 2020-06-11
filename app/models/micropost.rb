class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :picture, presence: true
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  
  def Micropost.including_replies(user_id)
    # Micropostsテーブルから、下記のいずれか条件の投稿を取得する
    #   自分がフォローしている人
    #   自分のマイクロポスト
    #   返信先が自分になっているマイクロポスト
    Micropost.where("user_id        IN (:following_ids)
                     OR user_id     =   :user_id
                     OR in_reply_to =   :user_id"         , following_ids: @user.following_ids, user_id: user_id)
  end
  
    private
  
      # アップロードされた画像のサイズをバリデーションする
      def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "5MBよりも小さなサイズにしてください")
        end
      end
  
end
