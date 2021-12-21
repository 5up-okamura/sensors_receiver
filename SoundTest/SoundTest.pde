/**
 * SoundTest
 */

// カウンター
int c = 0;

// 初期化
void setup() {
  size(512, 512);
  background(0);
  strokeWeight(2);
  setupServer(8080, "/");
  setupOsc();
}

// 画面更新
void draw() {
  updateOsc();
  drawGraph();
}

// グラフを描画
void drawGraph() {
  // cが0の時に画面をクリア
  if (c == 0) background(0);

  // 振幅の大きさ
  float w = height*0.125;

  float y1, y2;

  // xの線を描画
  stroke(255, 0, 0); // 赤
  y1 = pvec.x*w + height*0.25;
  y2 = vec.x*w + height*0.25;
  line(c, y1, c+1, y2);

  // yの線を描画
  stroke(0, 255, 0); // 緑
  y1 = pvec.y*w + height*0.5;
  y2 = vec.y*w + height*0.5;
  line(c, y1, c+1, y2);

  // zの線を描画
  stroke(0, 0, 255); // 青
  y1 = pvec.z*w + height*0.75;
  y2 = vec.z*w + height*0.75;
  line(c, y1, c+1, y2);

  // カウンターを増加して、幅で割った余り（0〜widthを繰り返す）
  c = (c + 1) % width;
}

// マウスクリック
void mousePressed() {
  c = 0;
}
