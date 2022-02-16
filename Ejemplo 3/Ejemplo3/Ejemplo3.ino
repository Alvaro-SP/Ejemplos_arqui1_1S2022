#include <LiquidCrystal.h>

LiquidCrystal lcd(22, 23, 24, 25, 26, 27);
int pin_trigger = 52;
int pin_echo = 53;
long dis;
long t;
byte caracter[] = {
  B01110,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B01110,
  B00000
};

void setup() {
  // put your setup code here, to run once:
  lcd.begin(16, 2); // 16 columnas 2 filas
  lcd.clear();
  lcd.setCursor(0, 0);//columnas, filas
  lcd.print("Hola mundo!!");
  lcd.createChar(0, caracter);
  pinMode(pin_trigger, OUTPUT);
  pinMode(pin_echo, INPUT);
  //lcd.setCursor(0, 1);
  //lcd.print("Soy un ejemplo");
}

void loop() {
  // put your main code here, to run repeatedly:
  //lcd.scrollDisplayLeft();
  lcd.setCursor(0, 1);
  int tiempo = millis() / 1000;
  lcd.print(tiempo);
  lcd.setCursor(9, 1);
  Serial.begin(9600);
  lcd.write(byte(0));

  //ultrasonico

  digitalWrite(pin_trigger, LOW);
  delayMicroseconds(5);
  digitalWrite(pin_trigger, HIGH);
  delayMicroseconds(10);
  t = pulseIn(pin_echo, HIGH);
  dis = long(0.017 * t);
  Serial.print("Distancia: ");
  Serial.print(dis);
  Serial.println("cm");
  lcd.setCursor(12, 1);
  lcd.print(dis);
  
  delay(500);
}
