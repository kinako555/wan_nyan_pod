class MicropostShareRelationshipsController < ApplicationController

  # micropostを取得できなかった場合のレンダリング先
  @@MISSING_RENDER_JS = 'missing_share_favorite'.freeze

  # POST micropost_share_relationships_path
  # フォロー
  def create
    @micropost = Micropost.find_by(id: params[:micropost_id])
    current_user.share_micropost(@micropost) if @micropost

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
    
  # DELETE micropost_share_relationships_path(micropost)
  # フォロー解除
  def destroy
    msr = MicropostShareRelationship.find_by(id: params[:id])
    if msr
      @micropost = msr.micropost
      current_user.unshare_micropost(@micropost)
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