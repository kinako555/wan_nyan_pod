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

  # お気に入り数トップの投稿50件
  def self.tops
    micropost_ids = "SELECT * FROM (SELECT micropost_id FROM micropost_favorite_relationships 
                        GROUP BY micropost_id LIMIT 50) AS ids"
    microposts = Micropost.where("id IN (#{micropost_ids})")
    microposts.sort_by{ |mp| mp.favorited_users.count }.reverse
  end

  # 一週間でお気に入りされた数が多い投稿100件
  def self.trends
    micropost_ids = "SELECT * FROM (SELECT micropost_id FROM micropost_favorite_relationships 
                                      WHERE created_at BETWEEN (NOW() - INTERVAL 1 WEEK) AND NOW() 
                                        GROUP BY micropost_id LIMIT 100) AS ids"
    microposts = Micropost.where("id IN (#{micropost_ids})")
    microposts.sort_by{ |mp| mp.favorited_users.count }.reverse
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
