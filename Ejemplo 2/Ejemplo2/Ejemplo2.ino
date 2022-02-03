int filas[] = {22, 23, 24, 25, 26, 27, 28, 29};
int columnas[] {46, 47, 48, 49, 50, 51, 52, 53};

void setup() {
  // put your setup code here, to run once:
  for(int i = 0; i < 8; i++){
    pinMode(filas[i], OUTPUT);
    pinMode(columnas[i], OUTPUT);
  }
  LimpiarMatriz();
  pinMode(31, OUTPUT);
  pinMode(32, OUTPUT);
  pinMode(33, OUTPUT);
  pinMode(34, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  /*for(int fila = 0; fila < 8; fila++){
    digitalWrite(filas[fila], HIGH);
    for(int columna = 0; columna < 8; columna++){
      digitalWrite(columnas[columna], LOW);
      delay(500);
      digitalWrite(columnas[columna], HIGH);
    }
    delay(500);
    LimpiarMatriz();
  }*/
  digitalWrite(31, HIGH);
  digitalWrite(32, LOW);
  digitalWrite(33, LOW);
  digitalWrite(34, LOW);
  delay(500);
  digitalWrite(31, LOW);
  digitalWrite(32, HIGH);
  digitalWrite(33, LOW);
  digitalWrite(34, LOW);
  delay(500);
  digitalWrite(31, LOW);
  digitalWrite(32, LOW);
  digitalWrite(33, HIGH);
  digitalWrite(34, LOW);
  delay(500);
  digitalWrite(31, LOW);
  digitalWrite(32, LOW);
  digitalWrite(33, HIGH);
  digitalWrite(34, LOW);
  delay(500);
}

void LimpiarMatriz(){
  for(int i = 0; i < 8; i++){
    digitalWrite(filas[i], LOW);
    digitalWrite(columnas[i], HIGH);
  }
}
