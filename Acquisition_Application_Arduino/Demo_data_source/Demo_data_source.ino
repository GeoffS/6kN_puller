void setup() 
{
  Serial.begin(9600, SERIAL_8N1);
}

float x = 0.0;
float y = 0.0;
int state = 0;

void loop() 
{
  Serial.print(x);
  Serial.print(",");
  Serial.println(y);
  x += 0.1;
  // y += 0.15;
  switch (state) 
  {
    case 0:
    if(y>20) state=1;
    y += 0.15;
    break;

    case 1:
    if(y<-2) state=2;
    y -= 0.3;
    break;

    case 2:
    if(y>5) state=0;
    y += 0.3;
    break;

    default:
    state = 0;
  }
  delay(200);
}
