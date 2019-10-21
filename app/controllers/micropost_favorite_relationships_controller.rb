class MicropostFavoriteRelationshipsController < ApplicationController

    # micropostを取得できなかった場合のレンダリング先
    @@MISSING_RENDER_JS = 'missing_share_favorite'.freeze
  
    # POST micropost_favorite_relationships_path
    # フォロー
    def create    
      @micropost = Micropost.find(params[:micropost_id])
      current_user.favorite_micropost(@micropost)

      respond_to do |format|
        format.html
        format.js
      end
    end
      
    # DELETE micropost_favorite_relationships_path(micropost)
    # フォロー解除
    def destroy
      mfr = MicropostFavoriteRelationship.find(params[:id])
      @micropost = mfr.micropost
      current_user.unfavorite_micropost(@micropost)

      respond_to do |format|
        format.html
        format.js
      end
    end
  
  end