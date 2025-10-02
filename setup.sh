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
# MEDAL_IMAGE_URL="https://your-server.com/public/medal_$(shuf -i 1-4 -n 1).png"
# MEDAL_IMAGE_URL="/medal_$(shuf -i 1-7 -n 1).png"
MEDAL_IMAGE_URL="http://image-asset-depo:3000/public/medal_random.png"
sudo curl -o "/opt/app/public/medal_image.png" "$MEDAL_IMAGE_URL"
# 画像の参照パスをローカルのファイルに変更
MEDAL_IMAGE_URL="/medal_image.png"

# VMスペック情報の取得
CPU_CORES=$(nproc)
# MEMORY_GB=$(echo "scale=2; $(free -m | awk 'NR==2{print $2}') / 1024" | bc)
MEMORY_MB=$(free -m | awk 'NR==2{print $2}')
MEMORY_GB=$((MEMORY_MB / 1024))
DISK_GB=$(df -h --output=size / | tail -n 1 | sed 's/G//')
OS_NAME=$(grep -oP '(?<=^NAME=).*' /etc/os-release | tr -d '"')
OS_VERSION=$(grep -oP '(?<=^VERSION_ID=).*' /etc/os-release | tr -d '"')

# 設定ファイルを生成
# echo "{\"hostname\": \"$HOST_NAME\", \"medalUrl\": \"$MEDAL_IMAGE_URL\"}" > config.json
echo "{\"hostname\": \"$HOST_NAME\", \"medalUrl\": \"$MEDAL_IMAGE_URL\", \"specs\": {\"cpu\": \"${CPU_CORES}\", \"memory\": \"${MEMORY_MB} MB\", \"disk\": \"${DISK_GB}GB\", \"os_name\": \"${OS_NAME}\", \"os_version\": \"${OS_VERSION}\"}}" > config.json

# アプリケーションをバックグラウンドで起動
node server.js &
