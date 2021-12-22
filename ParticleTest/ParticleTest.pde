/**
 * ParticleTest
 * https://processing.org/examples/simpleparticlesystem.html
 */

ParticleSystem ps;

PImage img;

// 初期化
void setup() {
  size(512, 512);
  setupServer(8080, "/");
  
  // パーティクルの画像をロード
  img = loadImage("particle.png");
  
  // パーティクルの発火位置
  float px = width/2;
  float py = height/10;
  // パーティクルシステムを初期化
  ps = new ParticleSystem(new PVector(px, py));
}

// 画面更新
void draw() {
  // 背景色をセット
  background(0);
  // 5フレームに一回パーティクルを追加
  if (frameCount % 5 == 0) {
    ps.addParticle(vec);
  }
  // パーティクルシステム（全てのパーティクル）を更新
  ps.run();
}
