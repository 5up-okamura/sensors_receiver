import processing.sound.*;

/**
 * FaceTest
 */

// 初期化
void setup() {
  size(512, 512);
  setupServer(8080, "/");
}

// 画面更新
void draw() {
  // 背景色をセット
  background(0);
  // 顔を描画
  if (faces.size() > 0) {
    Face f = faces.get(0);

    float x = f.origin.x;
    float y = f.origin.y;
    float w = f.width;
    float h = f.height;

    // 円の描画位置を左上にする
    ellipseMode(CORNER);

    // 白
    fill(255);

    // 輪郭を描画
    ellipse(x, y, w, h);

    // 中心位置
    float cx = x + w/2 + f.yaw * 2;
    float cy = y + h/2;
    
    // 描画位置を移動
    translate(cx, cy);
    
    // 回転
    rotate(radians(f.roll));

    // 円の描画位置を中心にする
    ellipseMode(CENTER);

    // 黒
    fill(0);

    // 左目
    ellipse(-w*0.2, -h*0.1, w*0.2, h*0.2*f.eyeOpenL);

    // 右目
    ellipse(w*0.2, -h*0.1, w*0.2, h*0.2*f.eyeOpenR);
    
    // 口
    ellipse(0, h*0.2, w*0.3, h*0.1*f.smiling);
  }
}
