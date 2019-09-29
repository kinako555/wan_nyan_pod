class RelationshipsController < ApplicationController

    # POST relationships_path
    # フォロー
    def create
      @user = User.find(params[:followed_id])
      current_user.follow(@user)
      respond_to do |format|
        # どちらかを実行
        format.html { redirect_to @user }
        format.js
      end
    end
  
    # DELETE relationships_path(Relationship)
    # フォロー解除
    def destroy
      @user = Relationship.find(params[:id]).followed
      current_user.unfollow(@user)
      respond_to do |format|
        # どちらかを実行
        format.html { redirect_to @user }
        format.js
      end
    end

end
