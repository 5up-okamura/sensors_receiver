import websockets.*;

// WebSocketサーバ
// https://github.com/alexandrainst/processing_websockets
WebsocketServer ws;

// ベクター
PVector vec = new PVector(0, 0, 0);
PVector pvec = new PVector(0, 0, 0);

// 顔認識
ArrayList<Face> faces = new ArrayList<Face>();

// バーコード
ArrayList<String> barcodes = new ArrayList<String>();

// サーバを初期化
void setupServer(int port, String uri) {
  // WebSocketサーバを起動
  ws = new WebsocketServer(this, port, uri);
}

// メッセージを受信
void webSocketServerEvent(String msg) {
  // メッセージを解析
  JSONObject json = parseJSONObject(msg);
  // 結果なし
  if (json == null) return;

  // idごとに処理
  String id = json.getString("id");
  switch (id) {
  case "acc":
    // 加速度センサー
    // https://docs.expo.dev/versions/latest/sdk/accelerometer/
  case "gyr":
    // ジャイロスコープ
    // https://docs.expo.dev/versions/v44.0.0/sdk/gyroscope/
  case "mag":
    // 磁気センサー
    // https://docs.expo.dev/versions/v44.0.0/sdk/magnetometer/
    {
      // 前回の値を格納
      pvec.set(vec);
      // 値を格納
      vec.set(json.getFloat("x"), json.getFloat("y"), json.getFloat("z"));
      break;
    }

  case "bro":
    // 気圧計
    // https://docs.expo.dev/versions/v44.0.0/sdk/barometer/
    {
      float p = json.getFloat("pressure");
      float r = json.getFloat("relativeAltitude");
      println("pressure:" + p + " relativeAltitude:" + r);
      break;
    }

  case "mot":
    // デバイスの動きと向き
    // https://docs.expo.dev/versions/v44.0.0/sdk/devicemotion/
    {
      // 前回の値を格納
      pvec.set(vec);

      int o = json.getInt("orientation");

      JSONObject acc = json.getJSONObject("acceleration");
      // 値を格納
      vec.set(acc.getFloat("x"), acc.getFloat("y"), acc.getFloat("z"));

      JSONObject aig = json.getJSONObject("accelerationIncludingGravity");
      float x2 = aig.getFloat("x");
      float y2 = aig.getFloat("y");
      float z2 = aig.getFloat("z");

      JSONObject r = json.getJSONObject("rotation");
      float g = r.getFloat("gamma");
      float b = r.getFloat("beta");
      float a = r.getFloat("alpha");

      JSONObject r2 = json.getJSONObject("rotationRate");
      float g2 = r2.getFloat("gamma");
      float b2 = r2.getFloat("beta");
      float a2 = r2.getFloat("alpha");

      println("orientation:" + o);
      println("acceleration x:" + vec.x + " y:" + vec.y + " z:" + vec.z);
      println("accelerationIncludingGravity x:" + x2 + " y:" + y2 + " z:" + z2);
      println("rotation gamma:" + g + " beta:" + b + " alpha:" + a);
      println("rotationRate gamma:" + g2 + " beta:" + b2 + " alpha:" + a2);
      break;
    }

  case "ped":
    // 歩数計
    // https://docs.expo.dev/versions/v44.0.0/sdk/pedometer/
    {
      int s = json.getInt("step");
      println("step:" + s);
      break;
    }

  case "fac":
    // 顔認識
    // https://docs.expo.dev/versions/v44.0.0/sdk/facedetector/
    {
      // 前回の値を消去
      faces.clear();

      JSONArray fc = json.getJSONArray("faces");
      for (int i = 0; i < fc.size(); i++) {
        Face face = new Face(fc.getJSONObject(i));
        println("face" + i + ":" + face);
        // 値を追加
        faces.add(face);
      }
      break;
    }

  case "bar":
    // バーコード認識
    // https://docs.expo.dev/versions/v44.0.0/sdk/bar-code-scanner/
    {
      String s = json.getString("result");
      println("barcode:" + s);
      // 値を追加
      barcodes.add(s);
      // スキャンされた文字を処理
      onScan(s);
      break;
    }
  }
}

/**
 * Face
 */
class Face {
  int id;
  PVector origin;
  float width, height;
  float roll, yaw; // Roll/Yaw Angle
  float smiling; // Smiling Probability
  PVector earL, earR; // Ear Position
  PVector eyeL, eyeR; // Eye Position
  float eyeOpenL, eyeOpenR; // Eye Open Probability
  PVector cheekL, cheekR; // Cheek Position
  PVector mouth, mouthL, mouthR; // Mouth Position
  PVector nose; // Nose Base Position

  Face(JSONObject f) {
    if (!f.isNull("faceID")) this.id = f.getInt("faceID");

    if (!f.isNull("bounds")) {
      JSONObject bounds = f.getJSONObject("bounds");
      JSONObject ori = bounds.getJSONObject("origin");
      this.origin = new PVector(ori.getFloat("x"), ori.getFloat("y"));
      JSONObject siz = bounds.getJSONObject("size");
      this.width = siz.getFloat("width");
      this.height = siz.getFloat("height");
    }

    if (!f.isNull("rollAngle")) this.roll = f.getFloat("rollAngle");
    if (!f.isNull("yawAngle")) this.yaw = f.getFloat("yawAngle");

    if (!f.isNull("smilingProbability")) this.smiling = f.getFloat("smilingProbability");

    if (!f.isNull("leftEarPosition")) {
      JSONObject earL = f.getJSONObject("leftEarPosition");
      this.earL = new PVector(earL.getFloat("x"), earL.getFloat("y"));
    }
    if (!f.isNull("rightEarPosition")) {
      JSONObject earR = f.getJSONObject("rightEarPosition");
      this.earR = new PVector(earR.getFloat("x"), earR.getFloat("y"));
    }

    if (!f.isNull("leftEyePosition")) {
      JSONObject eyeL = f.getJSONObject("leftEyePosition");
      this.eyeL = new PVector(eyeL.getFloat("x"), eyeL.getFloat("y"));
    }
    if (!f.isNull("rightEyePosition")) {
      JSONObject eyeR = f.getJSONObject("rightEyePosition");
      this.eyeR = new PVector(eyeR.getFloat("x"), eyeR.getFloat("y"));
    }

    if (!f.isNull("leftEyeOpenProbability")) this.eyeOpenL = f.getFloat("leftEyeOpenProbability");
    if (!f.isNull("rightEyeOpenProbability")) this.eyeOpenR = f.getFloat("rightEyeOpenProbability");

    if (!f.isNull("leftCheekPosition")) {
      JSONObject cheekL = f.getJSONObject("leftCheekPosition");
      this.cheekL = new PVector(cheekL.getFloat("x"), cheekL.getFloat("y"));
    }
    if (!f.isNull("rightCheekPosition")) {
      JSONObject cheekR = f.getJSONObject("rightCheekPosition");
      this.cheekR = new PVector(cheekR.getFloat("x"), cheekR.getFloat("y"));
    }

    if (!f.isNull("mouthPosition")) {
      JSONObject mouth = f.getJSONObject("mouthPosition");
      this.mouth = new PVector(mouth.getFloat("x"), mouth.getFloat("y"));
    }
    if (!f.isNull("leftMouthPosition")) {
      JSONObject mouthL = f.getJSONObject("leftMouthPosition");
      this.mouthL = new PVector(mouthL.getFloat("x"), mouthL.getFloat("y"));
    }
    if (!f.isNull("rightMouthPosition")) {
      JSONObject mouthR = f.getJSONObject("rightMouthPosition");
      this.mouthR = new PVector(mouthR.getFloat("x"), mouthR.getFloat("y"));
    }

    if (!f.isNull("noseBasePosition")) {
      JSONObject nose = f.getJSONObject("noseBasePosition");
      this.nose = new PVector(nose.getFloat("x"), nose.getFloat("y"));
    }
  }
  
  @Override
  public String toString() {
      String t = "";
      t += " id:" + id;
      if (this.origin != null) t += " origin:" + origin;
      t += " width:" + width;
      t += " height:" + height;
      t += " roll:" + roll;
      t += " yaw:" + yaw; // Roll/Yaw Angle
      t += " smiling:" + smiling; // Smiling Probability
      if (this.earL != null) t += " earL:" + earL;
      if (this.earR != null) t += " earR:" + earR; // Ear Position
      if (this.eyeL != null) t += " eyeL:" + eyeL;
      if (this.eyeR != null) t += " eyeR:" + eyeR; // Eye Position
      t += " eyeOpenL:" + eyeOpenL;
      t += " eyeOpenR:" + eyeOpenR; // Eye Open Probability
      if (this.cheekL != null) t += " cheekL:" + cheekL;
      if (this.cheekR != null) t += " cheekR:" + cheekR; // Cheek Position
      if (this.mouth != null) t += " mouth:" + mouth;
      if (this.mouthL != null) t += " mouthL:" + mouthL;
      if (this.mouthR != null) t += " mouthR:" + mouthR; // Mouth Position
      if (this.nose != null) t += " nose:" + nose; // Nose Base Position
      return super.toString() + t;
  }
}
