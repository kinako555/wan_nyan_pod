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
    # passive_relationships----------------------------------------
    # followed_id          : follower_id
    # インスタンスのuser_id : インスタンスがフォローされているuser_id
    # -------------------------------------------------------------
    has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent:   :destroy
    # active_relationshipsのfollowed_idにユーザーを紐付ける
    has_many :following, through: :active_relationships, source: :followed
    # passive_relationshipsのfollower_idにユーザーを紐付ける
    has_many :followers, through: :passive_relationships, source: :follower

    attr_accessor :remember_token

    before_save :downcase_email

    mount_uploader :icon, PictureUploader

    validates :name,     presence: true, 
                         length: { maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,    presence: true, 
                         length: { maximum: 255 }, 
                         format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }

    # 渡された文字列のハッシュ値を返す
    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
        # 2番目のウィンドウでログアウトするユーザーを想定して
        # ログアウトしている場合はfalseを返す(remember_digest)
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
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

    private 

        # メールアドレスをすべて小文字にする
        def downcase_email
            self.email = email.downcase
        end
end
