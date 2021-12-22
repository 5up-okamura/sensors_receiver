import processing.sound.*;

/**
 * BarcodeTest
 *
 * QRコード生成ツール https://spc.askul.co.jp/portal/print/qrcode
 */

// カラー
float c = 0;

// 画像
PImage img;

// 初期化
void setup() {
  size(512, 512);
  setupServer(8080, "/");
  // ダミー画像をロード
  img = loadImage("dot.png");
}

// 画面更新
void draw() {
  // 背景色をセット
  background(round(c));
  // カラーを0（黒）に近付ける
  c *= 0.96;
  
  // 画像の色（透明度）をセット
  tint(255, round(c));
  // 画像を画面の中心に表示するために座標を算出
  int imgX = (width - img.width)/2;
  int imgY = (height - img.height)/2;
  // 画像を表示
  image(img, imgX, imgY);
}

// スキャンされた文字を処理
void onScan(String s) {
  // 音声ファイルをロード
  SoundFile file = new SoundFile(this, s + ".WAV");
  // 再生
  file.play();
  // カラーを255（白）にする
  c = 255;
  // 画像をロード
  img = loadImage(s + ".png");
}
