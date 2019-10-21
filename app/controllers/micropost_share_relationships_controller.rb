class MicropostShareRelationshipsController < ApplicationController

  # micropostを取得できなかった場合のレンダリング先
  @@MISSING_RENDER_JS = 'missing_share_favorite'.freeze

  # POST micropost_share_relationships_path
  # フォロー
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.share_micropost(@micropost)

    respond_to do |format|
      #format.html
      format.js
    end
  end
    
  # DELETE micropost_share_relationships_path(micropost)
  # フォロー解除
  def destroy
    msr = MicropostShareRelationship.find(params[:id])
    @micropost = msr.micropost
    current_user.unshare_micropost(@micropost)
    
    respond_to do |format|
        format.html
        format.js
    end
  end

end