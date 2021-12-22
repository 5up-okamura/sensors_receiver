// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  // パーティクルシステムを初期化
  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  // パーティクルを追加
  void addParticle(PVector v) {
    // パーティクルを生成
    Particle p = new Particle(origin);
    // パーティクルの速度をセット
    p.velocity = new PVector(v.x, v.y);
    // パーティクルを追加
    particles.add(p);
  }

  // パーティクルシステム（全てのパーティクル）を更新
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
