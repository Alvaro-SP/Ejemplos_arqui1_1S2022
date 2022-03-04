float LDR;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  LDR = analogRead(A0);
  Serial.print("Valor LDR = ");
  Serial.println(LDR);
  delay(1000);
}
