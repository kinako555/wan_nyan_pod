class MicropostsFunctionRelationshipsController < ApplicationController

    # POST share_micropost_path(Micropost)
    # シェア
    def create_share
        @micropost = Micropost.find(params[:checked_id])
        current_user.share_micropost(@micropost)
        respond_to do |format|
          # どちらかを実行
          format.html
          format.js
        end
      end
    
      # DELETE share_micropost_path(Micropost)
      # シェア解除解除
      def destroy_share
        @micropost = Relationship.find(params[:id]).shared
        current_user.unshare_micropost(@micropost)
        respond_to do |format|
          # どちらかを実行
          format.html
          format.js
        end
      end

end