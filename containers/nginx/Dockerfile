FROM nginx:1.15.8

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
ADD wan_nyan_pod.conf /etc/nginx/conf.d/wan_nyan_pod.conf

# ビルド完了後にNginxを起動
# dockerコンテナの場合フォアグランドで動かさなければならない
# -g いらない可能性
CMD /usr/sbin/nginx 'daemon off;' -c /etc/nginx/nginx.conf