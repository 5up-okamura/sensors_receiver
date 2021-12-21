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
      String r = json.getString("result");
      println("result:" + r);
      // 値を追加
      barcodes.add(r);
      onScan(r);
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
    this.id = f.getInt("faceID");

    JSONObject b = f.getJSONObject("bounds");
    JSONObject o = b.getJSONObject("origin");
    this.origin = new PVector(o.getFloat("x"), o.getFloat("y"));
    JSONObject s = b.getJSONObject("size");
    this.width = s.getFloat("width");
    this.height = s.getFloat("height");

    this.roll = f.getFloat("rollAngle");
    this.yaw = f.getFloat("yawAngle");

    this.smiling = f.getFloat("smilingProbability");

    JSONObject earL = f.getJSONObject("leftEarPosition");
    this.earL = new PVector(earL.getFloat("x"), earL.getFloat("y"));
    JSONObject earR = f.getJSONObject("rightEarPosition");
    this.earR = new PVector(earR.getFloat("x"), earR.getFloat("y"));

    JSONObject eyeL = f.getJSONObject("leftEyePosition");
    this.eyeL = new PVector(eyeL.getFloat("x"), eyeL.getFloat("y"));
    JSONObject eyeR = f.getJSONObject("rightEyePosition");
    this.eyeR = new PVector(eyeR.getFloat("x"), eyeR.getFloat("y"));

    this.eyeOpenL = f.getFloat("leftEyeOpenProbability");
    this.eyeOpenR = f.getFloat("rightEyeOpenProbability");

    JSONObject cheekL = f.getJSONObject("leftCheekPosition");
    this.cheekL = new PVector(cheekL.getFloat("x"), cheekL.getFloat("y"));
    JSONObject cheekR = f.getJSONObject("rightCheekPosition");
    this.cheekR = new PVector(cheekR.getFloat("x"), cheekR.getFloat("y"));

    JSONObject mouth = f.getJSONObject("mouthPosition");
    this.mouth = new PVector(mouth.getFloat("x"), mouth.getFloat("y"));
    JSONObject mouthL = f.getJSONObject("leftMouthPosition");
    this.mouthL = new PVector(mouthL.getFloat("x"), mouthL.getFloat("y"));
    JSONObject mouthR = f.getJSONObject("rightMouthPosition");
    this.mouthR = new PVector(mouthR.getFloat("x"), mouthR.getFloat("y"));

    JSONObject nose = f.getJSONObject("noseBasePosition");
    this.nose = new PVector(nose.getFloat("x"), nose.getFloat("y"));
  }
}
