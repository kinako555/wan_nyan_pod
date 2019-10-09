class Micropost < ApplicationRecord
  belongs_to :user
  has_many :passive_micropost_share_relationships, class_name:  MicropostShareRelationship.name,
                                                   foreign_key: "user_id",
                                                   dependent:   :destroy
  has_many :shared_users, through: :passive_micropost_share_relationships, source: :user

  has_many :passive_favorite_relationships, class_name:  MicropostFavoriteRelationship.name,
                                            foreign_key: "user_id",
                                            dependent:   :destroy
  has_many :favorited_users, through: :passive_favorite_relationships, source: :user

  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, MicropostPictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
