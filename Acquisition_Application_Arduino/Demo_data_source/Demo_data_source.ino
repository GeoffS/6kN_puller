void setup() 
{
  Serial.begin(9600, SERIAL_8N1);
}

float x = 0.0;
float y = 0.0;

void loop() 
{
  Serial.print(x);
  Serial.print(",");
  Serial.println(y);
  x += 0.1;
  y += 0.15;
  delay(200);
}
