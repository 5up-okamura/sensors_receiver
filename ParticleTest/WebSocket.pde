import websockets.*;

// WebSocketサーバ
// https://github.com/alexandrainst/processing_websockets
WebsocketServer ws;

// 加速度
float acceleration = 1.0;

// 座標
float x, y, z;

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
      x = json.getFloat("x");
      y = json.getFloat("y");
      z = json.getFloat("z");
      //println(" x:" + x + " y:" + y + " z:" + z);
      if (id.equals("acc"))
        acceleration = sqrt(x*x + y*y + z*z);
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
      int o = json.getInt("orientation");
      JSONObject acc = json.getJSONObject("acceleration");
      float x = acc.getFloat("x");
      float y = acc.getFloat("y");
      float z = acc.getFloat("z");
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
      println("acceleration x:" + x + " y:" + y + " z:" + z);
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
      float s = json.getFloat("smiling");
      float l = json.getFloat("leftEye");
      float r = json.getFloat("rightEye");
      println("smiling:" + s + " leftEye:" + l + " rightEye:" + r);
      break;
    }

  case "bar":
    // バーコード認識
    // https://docs.expo.dev/versions/v44.0.0/sdk/bar-code-scanner/
    {
      String r = json.getString("result");
      println("result:" + r);
      break;
    }
  }
}
