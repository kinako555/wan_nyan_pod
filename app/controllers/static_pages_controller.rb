class StaticPagesController < ApplicationController

  skip_before_action :require_login, only: [:about]
  
  # ヘルプページを作成する際はコメントを外す
  #def help
  #end

  def about
  end
end
