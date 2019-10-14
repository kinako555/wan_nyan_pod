class User < ApplicationRecord
    authenticates_with_sorcery!
    has_secure_password

    has_many :microposts, dependent: :destroy
    # active_relationships---------------------------------------
    # follower_id          : followed_id
    # インスタンスのuser_id : インスタンスがフォローしているuser_id
    # -----------------------------------------------------------
    has_many :active_relationships, class_name:  Relationship.name,
                                    foreign_key: "follower_id",
                                    dependent:   :destroy
    # active_relationshipsのfollowed_idにユーザーを紐付ける
    has_many :following, through: :active_relationships, source: :followed
    # passive_relationships----------------------------------------
    # followed_id          : follower_id
    # インスタンスのuser_id : インスタンスがフォローされているuser_id
    # -------------------------------------------------------------
    has_many :passive_relationships, class_name:  Relationship.name,
                                     foreign_key: "followed_id",
                                     dependent:   :destroy   
    # passive_relationshipsのfollower_idにユーザーを紐付ける
    has_many :followers, through: :passive_relationships, source: :follower
    
    has_many :active_micropost_share_relationships, class_name: MicropostShareRelationship.name,
                                                     foreign_key: "user_id",
                                                     dependent:   :destroy
    has_many :sharering_microposts, through: :active_micropost_share_relationships, source: :micropost

    has_many :acticve_micropost_favorite_relationships, class_name:  MicropostFavoriteRelationship.name,
                                                        foreign_key: "user_id",
                                                        dependent:   :destroy
    has_many :favoriting_microposts, through: :acticve_micropost_favorite_relationships, source: :micropost

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

    # ホーム画面で表示する投稿一覧
    def home_microposts
        rtn_microposts = microposts.to_a
        sharering_microposts.each do |mp|
            rtn_microposts.push(format_shared_micropost(active_micropost_share_relationships, mp))
        end
        rtn_microposts.sort_by{ |mp| mp.updated_at }.reverse # 更新日時順にソート
    end

    # お気に入り一覧をシェアした日時に並び替える
    def sorted_favoriting_microposts
        favoriting_microposts.each { |mp| mp.updated_at = acticve_micropost_favorite_relationships.select(:updated_at)
                                                                                                 .where('micropost_id = ?', mp.id)
                                                                                                 .first.updated_at }
        favoriting_microposts.sort_by{ |mp| mp.updated_at }.reverse # 更新日時順にソート
    end

    # 自分とフォローしているMicropostsを返す
    # TODO: 処理に時間がかかっているためなんとかしたい
    def timeline
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        rtn_timeline =  Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
        add_microposts = []
        # フォローしているユーザーがシェアしている投稿を抽出する
        following.each do |followed|
            followed.sharering_microposts.each do |micropost|             
                next if following?(micropost.user) # シェアした投稿がフォロワーのものであれば表示しない
                next if rtn_timeline.find_by(id: micropost.id) # 同じ投稿は表示しない
                format_shared_micropost(followed.active_micropost_share_relationships, micropost)
                micropost.sharer_name = followed.name
                add_microposts.push(micropost)
            end
        end
        rtn_timeline = rtn_timeline.to_a
        rtn_timeline.push(add_microposts).flatten! # 配列中に含まれる配列を親配列に並べる
        rtn_timeline.sort_by{ |mp| mp.updated_at }.reverse # 更新日時順にソート
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
        sharering_microposts << micropost
    end
    # 投稿のシェアを解除する
    def unshare_micropost(micropost)
        active_micropost_share_relationships.find_by(micropost_id: micropost.id).destroy
    end

    # 投稿をシェアしていたらtrueを返す
    def sharering_micropost?(micropost)
        sharering_microposts.include?(micropost)
    end

    # 投稿をファボする
    def favorite_micropost(micropost)
        favoriting_microposts << micropost
    end
    # 投稿のファボを解除する
    def unfavorite_micropost(micropost)
        acticve_micropost_favorite_relationships.find_by(micropost_id: micropost.id).destroy
    end

    # 投稿をファボしていたらtrueを返す
    def favoriting_micropost?(micropost)
        favoriting_microposts.include?(micropost)
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

        # micropostの更新日時をシェア実行時に更新
        # シェアしたユーザーネームを設定する
        def format_shared_micropost(active_micropost_share_relationships, micropost)
            micropost.updated_at = active_micropost_share_relationships.select(:updated_at)
                                                                        .where('micropost_id = ?', micropost.id)
                                                                        .first.updated_at
            micropost
        end

end
