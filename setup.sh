#!/bin/bash

# Node.jsとnpmをインストール
sudo dnf install -y nodejs npm git

# GitHubからアプリケーションコードをクローン
git clone https://github.com/toaraki/rhcharcard2025.git /opt/app

# ディレクトリに移動
cd /opt/app

# 依存関係をインストール
npm install

# 環境変数を設定 (ホスト名とメダル情報を渡す)
# cloud-initのuser-dataでこれらの変数を設定してください
HOST_NAME=$(hostname)
#MEDAL_IMAGE_URL="https://your-server.com/public/medal_$(shuf -i 1-4 -n 1).png"
MEDAL_IMAGE_URL="/medal_$(shuf -i 1-4 -n 1).png"

# 設定ファイルを生成
echo "{\"hostname\": \"$HOST_NAME\", \"medalUrl\": \"$MEDAL_IMAGE_URL\"}" > config.json

# アプリケーションをバックグラウンドで起動
node server.js &
