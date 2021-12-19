/**
 * sensors_receiver2
 * https://processing.org/examples/simpleparticlesystem.html
 */

ParticleSystem ps;

// 初期化
void setup() {
  size(512, 512);
  setupServer(8080, "/");
  ps = new ParticleSystem(new PVector(width/2, 50));
}

// 画面更新
void draw() {
  background(0);
  ps.addParticle(new PVector(x, y));
  ps.run();
}
