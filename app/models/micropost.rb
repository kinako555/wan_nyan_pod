class Micropost < ApplicationRecord
  belongs_to :user
  has_many :passive_micropost_share_relationships, class_name:  MicropostShareRelationship.name,
                                                   foreign_key: "micropost_id",
                                                   dependent:   :destroy
  has_many :shared_users, through: :passive_micropost_share_relationships, source: :user

  has_many :passive_favorite_relationships, class_name:  MicropostFavoriteRelationship.name,
                                            foreign_key: "micropost_id",
                                            dependent:   :destroy
  has_many :favorited_users, through: :passive_favorite_relationships, source: :user

  attr_accessor :sharer_name

  default_scope -> { order(created_at: :desc) }
  has_many_attached :pictures # Active Storage
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :validate_pictures


  def shared?
    sharer_name ? true : false
  end

  def shared_message
    "#{sharer_name}さんがシェアしました。"
  end

  private

    def validate_pictures
      return if !pictures.attached?
      pictures.each do |picture|
        if picture.blob.byte_size > 5.megabytes
          pictures.purge
          return
        elsif !image?(picture)
          pictures.purge
          return
        end
      end
    end

    def image?(picture)
      %w[image/jpg image/jpeg image/gif image/png].include?(picture.blob.content_type)
    end

end
