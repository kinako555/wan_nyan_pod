class User < ApplicationRecord
    authenticates_with_sorcery!
    has_secure_password

    has_many :microposts, dependent: :destroy
    # active_relationships---------------------------------------
    # follower_id          : followed_id
    # インスタンスのuser_id : インスタンスがフォローしているuser_id
    # -----------------------------------------------------------
    has_many :active_relationships, class_name:  "Relationship",
                                    foreign_key: "follower_id",
                                    dependent:   :destroy
    # active_relationshipsのfollowed_idにユーザーを紐付ける
    has_many :following, through: :active_relationships, source: :followed
    # passive_relationships----------------------------------------
    # followed_id          : follower_id
    # インスタンスのuser_id : インスタンスがフォローされているuser_id
    # -------------------------------------------------------------
    has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent:   :destroy
    
    # passive_relationshipsのfollower_idにユーザーを紐付ける
    has_many :followers, through: :passive_relationships, source: :follower
    
    has_many :sharering_relationships, -> { where("function_type = ?", MicropostFunctionRelationship::function_type::SHARE) },
                                          class_name:  "MicropostFunctionRelationship",
                                          foreign_key: "checker_id",
                                          dependent:   :destroy
    had_many :sharering_microoposts, :sharering_relationships, source: :shared

    attr_accessor :remember_token

    before_save :downcase_email

    mount_uploader :icon, UserIconUploader

    validates :name,     presence: true, 
                         length: { maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,    presence: true, 
                         length: { maximum: 255 }, 
                         format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }
    validate  :picture_size

    # sorceryから提供されていないか確認
    # ユーザーが有効か
    def activated?
        activation_state == 'active'
    end

    # 自分とフォローしているMicropostsを返す
    def timeline
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
    end

    # ユーザーをフォローする
    def follow(other_user)
        following << other_user
    end

    # ユーザーをフォロー解除する
    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end

    # 現在のユーザーがフォローしてたらtrueを返す
    def following?(other_user)
        following.include?(other_user)
    end

    # 投稿をシェアする
    def share_micropost(micropost)
        # sharering_microoposts << micropost
        # 上のような方法を取りたいが、
        # 初期値にfunction_typeが必須なので下の方法をとる
        sharering_relationships.find_or_create_by(checked: micropost.id,
                                                  function_type: MicropostFunctionRelationship::function_type::SHARE)
    end
    
    # 投稿のシェア解除
    def unshare_micropost(micropost)
        sharering_relationships.find_by(checked_id: micropost.id).destroy
    end

    # 現在のユーザーがシェアしている投稿ならtrueを返す
    def sharering_micropost?(micropost)
        sharering_microoposts.include?(micropost)
    end

    private 

        # メールアドレスをすべて小文字にする
        def downcase_email
            self.email = email.downcase
        end

        # アップロードされた画像のサイズをバリデーションする
        def picture_size
            if icon.size > 5.megabytes
                errors.add(:picture, "should be less than 5MB")
            end
        end
end
