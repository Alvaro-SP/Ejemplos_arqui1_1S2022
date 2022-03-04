#include <EEPROM.h>

/*int ledPin = 22;
int estado = 0;
*/

struct usuario{
  char n;
  char p;
};

byte dato;
void setup() {
  // put your setup code here, to run once:
  /*pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  Serial.begin(9600);*/
  Serial.begin(9600);
  //lectura de un dato de la eeprom por posicion
  /*for(int direccion = 0; direccion < 1024; direccion++){
    dato = EEPROM.read(direccion);
    Serial.print(direccion);
    Serial.print(" = ");
    Serial.print(dato);
    Serial.println();
  }*/

  /*for(int i = 1; i <= 100; i++){
    EEPROM.write(i-1, i); 
  }*/
  usuario usr;
  usr.n = 'h';
  usr.p = 'o';
  EEPROM.update(50, 1);
  EEPROM.put(0, usr);
  /*for(int direccion = 0; direccion < 100; direccion++){
    dato = EEPROM.read(direccion);
    Serial.print(direccion);
    Serial.print(" = ");
    Serial.print(dato);
    Serial.println();
  }*/

  usuario usr1;
  EEPROM.get(0, usr1);
  Serial.print("usr1 = ");
  Serial.print(usr1.n);
  Serial.print(',');
  Serial.print(usr.p);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  /*if(Serial.available() > 0){
    estado = Serial.read();
    if(estado == 'E'){
      Serial.print('h');
      Serial.println();
    }
  }

  if(estado == 'E'){
    digitalWrite(ledPin, HIGH);
    estado = 0;
  }else if(estado == 'A'){
    digitalWrite(ledPin, LOW);
    estado = 0;
  }
  delay(1000);*/
}
