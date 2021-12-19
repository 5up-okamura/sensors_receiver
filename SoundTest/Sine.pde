import processing.sound.*;

// サインオシレーター 
SinOsc sine;

// 周波数
float freq = 0;

// サインオシレーターを初期化
void setupSine() {
  sine = new SinOsc(this);
  sine.freq(freq);
  sine.play();
}

// サインオシレーターを更新
void updateSine() {
  // 加速度を重力と比較
  if (acceleration < 0.98) {
    // 低い場合、周波通を高くする
    float v = (0.98 - acceleration)/0.98;
    freq += v * 40;
  } else {
    // 高い場合、周波通を0に近づける
    freq *= 0.9;
  }
  // 周波数を更新
  sine.freq(freq);
}
