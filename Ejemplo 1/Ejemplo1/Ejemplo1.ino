int entrada_btn1 = 22;//maneja el pin 22
int entrada_btn2 = 23;//maneja el pin 23
long entrada_pot; //maneja la entrada del potenciometro
int led = 3, brillo;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(entrada_btn1, INPUT);
  pinMode(entrada_btn2, INPUT);
  pinMode(24, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println("Hola mundo");
  entrada_pot = analogRead(A0);
  brillo = map(entrada_pot, 0, 1023, 0, 255);
  analogWrite(led, brillo);
  Serial.println(entrada_pot);
  if(digitalRead(entrada_btn1) == HIGH){
    Serial.println("Boton presionado");
  }else{
    Serial.println("Boton no presionado");
  }
  if(digitalRead(entrada_btn2) == HIGH){
    digitalWrite(24, LOW);
  }else{
    digitalWrite(24, HIGH);
  }
  delay(1000);
}
