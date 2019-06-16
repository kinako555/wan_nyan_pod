class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            flash[:success] = "投稿しました"
            redirect_to root_url
        else
            # TODO: ボタンを非活性にするやり方でやる
            @user = current_user
            @microposts = @user.microposts.where.not(id: nil)
            
            render 'users/home'
        end
    end
  
    def destroy
        @micropost.destroy
        flash[:success] = "削除しました"
        redirect_back(fallback_location: root_url) # 削除実行したページに戻る
    end

    private

        def micropost_params
            params.require(:micropost).permit(:content)
        end

        # 画面で選択したMicropostを代入する
        def correct_user
            @micropost = current_user.microposts.find_by(id: params[:id])
            redirect_to root_url if @micropost.nil?
        end
end
