class MicropostFavoriteRelationshipsController < ApplicationController

    # micropostを取得できなかった場合のレンダリング先
    @@MISSING_RENDER_JS = 'missing_share_favorite'.freeze
  
    # POST micropost_favorite_relationships_path
    # フォロー
    def create
      @micropost = Micropost.find_by(id: params[:micropost_id])
      current_user.favorite_micropost(@micropost) if @micropost
  
      if !@micropost.blank?
        respond_to do |format|
          format.html
          format.js
        end
      else
        respond_to do |format|
          format.html
          format.js { render @@MISSING_RENDER_JS }
        end
      end
    end
      
    # DELETE micropost_favorite_relationships_path(micropost)
    # フォロー解除
    def destroy
      mfr = MicropostFavoriteRelationship.find_by(id: params[:id])
      if mfr
        @micropost = mfr.micropost
        current_user.unfavorite_micropost(@micropost)
      end
      if @micropost
        respond_to do |format|
          format.html
          format.js
        end
      else
        respond_to do |format|
          format.html
          format.js { render @@MISSING_RENDER_JS }
        end
      end
    end
  
  end