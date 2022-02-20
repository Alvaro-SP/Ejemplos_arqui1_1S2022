#include <Wire.h>

void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  Wire.beginTransmission(245);
  Wire.write(5);
  Wire.endTransmission();
  delayMicroseconds(100);
  Wire.requestFrom(245, 4);
  while(Wire.available() > 0){
    char c = Wire.read();
    Serial.print(c);
  }
  Serial.println();
  delay(500);
}
