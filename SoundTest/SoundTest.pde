/**
 * sensors_receiver
 */

// カウンター
int c = 0;

// 前回の座標
float px, py, pz;

// 初期化
void setup() {
  size(512, 512);
  background(0);
  strokeWeight(2);
  setupServer(8080, "/");
  setupSine();
}

// 画面更新
void draw() {
  updateSine();
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
  y1 = px*w + height*0.25;
  y2 = x*w + height*0.25;
  line(c, y1, c+1, y2);

  // yの線を描画
  stroke(0, 255, 0); // 緑
  y1 = py*w + height*0.5;
  y2 = y*w + height*0.5;
  line(c, y1, c+1, y2);

  // zの線を描画
  stroke(0, 0, 255); // 青
  y1 = pz*w + height*0.75;
  y2 = z*w + height*0.75;
  line(c, y1, c+1, y2);

  // 座標を格納
  px = x;
  py = y;
  pz = z;

  // カウンターを増加して、幅で割った余り（0〜widthを繰り返す）
  c = (c + 1) % width;
}

// マウスクリック
void mousePressed() {
  c = 0;
}
