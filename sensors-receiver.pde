import websockets.*;
import processing.sound.*;

WebsocketServer ws;
SinOsc sine;
float freq = 0;
float acceleration = 1;
float x, y, z;
float c = 0;

void setup() {
  size(512, 512);
  background(0);
  strokeWeight(2);
  ws = new WebsocketServer(this, 8080, "/");
  //initSine();
}

void draw() {
  //updateSine();
  drawGraph();
}

void initSine() {
  sine = new SinOsc(this);
  sine.freq(freq);
  sine.play();
}

void updateSine() {
  if (acceleration < 0.98) {
    float v = (0.98 - acceleration)/0.98;
    freq += v * 20;
  } else {
    freq *= 0.9;
  }
  sine.freq(freq);
}

void drawGraph() {
  if (c == 0) background(0);

  float w = height*0.25;
  stroke(255, 0, 0);
  point(c, x*w + height*0.25);
  stroke(0, 255, 0);
  point(c, y*w + height*0.5);
  stroke(0, 0, 255);
  point(c, z*w + height*0.75);

  c = (c + 1) % width;
}

void mousePressed() {
  c = 0;
}

void webSocketServerEvent(String msg) {
  JSONObject json = parseJSONObject(msg);
  if (json == null) return;
  String id = json.getString("id");
  switch (id) {
  case "acc":
  case "gyr":
  case "mag": 
    {
      x = json.getFloat("x");
      y = json.getFloat("y");
      z = json.getFloat("z");
      //println("x:" + x + " y:" + y + " z:" + z);
      if (id == "acc") {
        acceleration = dist(0, 0, 0, x, y, z);
      }
      break;
    }
  case "bro": 
    {
      float p = json.getFloat("pressure");
      float r = json.getFloat("relativeAltitude");
      println("pressure:" + p + " relativeAltitude:" + r);
      break;
    }
  case "mot": 
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
    {
      int s = json.getInt("step");
      println("step:" + s);
      break;
    }
  case "fac": 
    {
      float s = json.getFloat("smiling");
      float l = json.getFloat("leftEye");
      float r = json.getFloat("rightEye");
      println("smiling:" + s + " leftEye:" + l + " rightEye:" + r);
      break;
    }
  case "bar": 
    {
      String r = json.getString("result");
      println("result:" + r);
      break;
    }
  }
}
