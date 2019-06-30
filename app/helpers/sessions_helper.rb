module SessionsHelper

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # ログインしているか
  def logged_in?
    !current_user.nil?
  end

  # 記憶したURLが存在する場合記憶したURLにリダイレクトする
  # 存在しない場合、受け取ったdefaultにリダイレクトする
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLをsessionに保存する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
