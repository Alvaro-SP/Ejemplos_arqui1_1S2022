#include <Wire.h>

void setup() {
  // put your setup code here, to run once:
  Wire.begin(245);
  Wire.onReceive(receiveEvent);
  Wire.onRequest(requestEvent);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(1000);
}

void receiveEvent(){
  while(Wire.available() > 0){
    int c = Wire.read();
    Serial.print(c);
  }
  Serial.println();
}

void requestEvent(){
  Wire.write("hola");
}
