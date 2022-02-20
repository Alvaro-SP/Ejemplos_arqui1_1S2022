#include <Servo.h>
#include <Stepper.h>

Stepper motor(32, 22, 23, 24, 25);
Servo servo;
int angulo = 0;

void setup() {
  // put your setup code here, to run once:
  motor.setSpeed(10);
  servo.attach(27);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  /*motor.step(32);
  delay(500);
  motor.step(-32);
  delay(500);*/
  for(angulo = 0; angulo < 180; angulo += 10){
    servo.write(angulo);
    delay(500);
  }
  for(angulo = 180; angulo >=1 ; angulo -=5){
    servo.write(angulo);
    delay(500);
  }
}
