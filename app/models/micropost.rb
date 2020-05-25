class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  
    private
  
      # アップロードされた画像のサイズをバリデーションする
      def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "5MBよりも小さなサイズにしてください")
        end
      end
  
end
