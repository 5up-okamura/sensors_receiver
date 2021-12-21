import processing.sound.*;

/**
 * BarcodeTest
 *
 * QRコード生成ツール https://spc.askul.co.jp/portal/print/qrcode
 */

// カラー
float c = 0;

// 初期化
void setup() {
  size(512, 512);
  background(0);
  setupServer(8080, "/");
}

// 画面更新
void draw() {
  // 背景色をセット
  background(round(c));
  // 0に近付ける
  c *= 0.96;
}

// スキャンされた
void onScan(String s) {
  // 音声ファイルをロード
  SoundFile file = new SoundFile(this, s + ".WAV");
  // 再生
  file.play();
  // カラーを255に
  c = 255;
}
