const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000; // アプリケーションがリッスンするポート

// テンプレートエンジンの設定
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// 静的ファイルの提供（CSS、画像など）
app.use(express.static(path.join(__dirname, 'public')));

// config.jsonから設定を読み込む
const configPath = path.join(__dirname, 'config.json');
let config = {};
try {
  const configFile = fs.readFileSync(configPath, 'utf8');
  config = JSON.parse(configFile);
} catch (err) {
  console.error('Error reading config.json:', err);
  // エラー時でもアプリが起動するようにデフォルト値を設定
  config = { hostname: 'Unknown VM', medalUrl: '/medal_1.png' };
}

// ルートエンドポイント
app.get('/', (req, res) => {
  // EJSテンプレートにデータを渡してレンダリング
  res.render('index', {
    hostname: config.hostname, // setup.shから渡されたホスト名
    medalUrl: config.medalUrl, // setup.shから渡されたメダルURL
    // 追加: チームロゴのパス
    teamLogoUrl: '/t-logo.png', // publicディレクトリからの相対パス
    specs: config.specs || {} // specsオブジェクトを追加
  });
});

// サーバーを起動
app.listen(port, () => {
  console.log(`VM Greeting App listening at http://localhost:${port}`);
});
