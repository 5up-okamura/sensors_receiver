// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    // 毎フレーム、パーティクルにかかる力（重力）
    acceleration = new PVector(0, 0.05);
    // パーティクルの速度
    velocity = new PVector(random(-1, 1), random(-2, 0));
    // パーティクルの座標
    position = l.copy();
    // パーティクルの生存時間
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    // パーティクルの生存時間を減らす（0になったら終了する）
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    //// パーティクルの線の色をセット
    //stroke(255, lifespan);
    
    //// パーティクルの塗りの色をセット
    //fill(255, lifespan);
    
    //// 大きさ8の円のパーティクルを描画
    //ellipse(position.x, position.y, 8, 8);
    
    //// 大きさ8の四角のパーティクルを描画
    //rect(position.x, position.y, 8, 8);
    
    // 画像の描画位置を中心にする
    imageMode(CENTER);
    
    // パーティクルの画像を描画
    image(img, position.x, position.y);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
