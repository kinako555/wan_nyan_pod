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

  attr_accessor :sharer_name

  default_scope -> { order(created_at: :desc) }
  has_many_attached :pictures # Active Storage
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }


  def shared?
    sharer_name ? true : false
  end

  def shared_message
    "#{sharer_name}さんがシェアしました。"
  end

end
