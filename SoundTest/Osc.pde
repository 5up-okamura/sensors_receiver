import processing.sound.*;

// オシレーター
SinOsc osc = new SinOsc(this);
//Pulse osc = new Pulse(this);
//SawOsc osc = new SawOsc(this);
//SqrOsc osc = new SqrOsc(this);
//TriOsc osc = new TriOsc(this);

// 周波数
float freq = 0;

// オシレーターを初期化
void setupOsc() {
  osc.freq(freq);
  osc.play();
}

// オシレーターを更新
void updateOsc() {
  // 加速度を重力と比較
  float mag = vec.mag();
  if (mag > 0 && mag < 0.98) {
    // 低い場合、周波通を高くする
    float v = (0.98 - mag)/0.98;
    freq += v * 40;
  } else {
    // 高い場合、周波通を0に近づける
    freq *= 0.9;
  }
  // 周波数を更新
  osc.freq(freq);
}
