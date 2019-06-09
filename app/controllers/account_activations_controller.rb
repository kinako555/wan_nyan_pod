class AccountActivationsController < ApplicationController

    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:success] = "ユーザーを作成しました。"
            redirect_to user
        else
            flash[:danger] = "リンクが有効ではありません"
            redirect_to login_path
        end
    end

end
