class StaticPagesController < ApplicationController

  def home
    if logged_in? 
      @user = current_user
      @microposts = @user.microposts
      @micropost = current_user.microposts.build
    else
      redirect_to login_path
    end
  end

  # ヘルプページを作成する際はコメントを外す
  #def help
  #end

  def about
  end
end
