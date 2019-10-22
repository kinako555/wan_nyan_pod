class MicropostsController < ApplicationController
    
    before_action :correct_user, only: :destroy

    def create
        pictures = format_pictures(params)
        value = { content: params[:content], pictures: pictures }

        @micropost = current_user.microposts.build(value)
        if @micropost.save
            flash[:success] = "投稿しました"
            redirect_to root_url
        else
            # TODO: ボタンを非活性にするやり方でやる
            @user = current_user
            @microposts = @user.microposts.where.not(id: nil)
            @sharering_or_favoriting_users
            render 'users/home'
        end
    end
  
    def destroy
        @micropost.destroy
        flash[:success] = "削除しました"
        redirect_back(fallback_location: root_url) # 削除実行したページに戻る
    end

    def favorited_users
        micropost = Micropost.find(params[:id])
        @sharering_or_favoriting_users = micropost.favorited_users

        respond_to do |format|
            format.js
        end
    end

    def shared_users
        micropost = Micropost.find(params[:id])
        @sharering_or_favoriting_users = micropost.shared_users
        
        respond_to do |format|
            format.html
            format.js
        end
    end

    def show_picture
        micropost = Micropost.find(params[:id])
        num =  params[:num]
        @picture = micropost.pictures[num.to_i]
        
        respond_to do |format|
            format.js
        end
    end

    def top
        @microposts = Micropost.tops
        @sharering_or_favoriting_users = [] #TODO: 消す
    end

    def trend
        @microposts = Micropost.trends
        @sharering_or_favoriting_users = [] #TODO: 消す

        respond_to do |format|
            format.js
        end
    end

    private

        def micropost_params
            params.require(:micropost).permit(:content, pictures: [])
        end

        # 個別のパラメータで送られたファイルを配列に入れる
        def format_pictures(v_params)
            rtn_pictures = []
            length = v_params[:pictures_length].to_i

            rtn_pictures.push(v_params[:pictures_0]) if length >= 1
            rtn_pictures.push(v_params[:pictures_1]) if length >= 2
            rtn_pictures.push(v_params[:pictures_2]) if length >= 3
            rtn_pictures.push(v_params[:pictures_3]) if length >= 4
            
            return rtn_pictures
        end

        # 画面で選択したMicropostを代入する
        def correct_user
            @micropost = current_user.microposts.find_by(id: params[:id])
            redirect_to root_url if @micropost.nil?
        end
end
