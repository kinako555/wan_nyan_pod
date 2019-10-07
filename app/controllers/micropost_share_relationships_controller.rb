class MicropostShareRelationshipsController < ApplicationController

  # POST micropost_share_relationships_path
  # フォロー
  def create
    @micropost = Micropost.find(params[:id])
    #current_user.share_micropost(@micropost)
    #respond_to do |format|
      # どちらかを実行
    #  format.html
    #  format.js
    #end
    redirect_to root_path
  end
    
  # DELETE micropost_share_relationships_path(micropost)
  # フォロー解除
  def destroy
    @micropost = Relationship.find(params[:id]).shared
    current_user.unshare_micropost(@micropost)
    #respond_to do |format|
      # どちらかを実行
    #  format.html
    # format.js
    #end
    redirect_to root_path
  end

end