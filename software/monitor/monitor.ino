const char ADDR[] = {27, 26, 25, 24, 23, 22, 21, 20, 45, 44, 43, 42, 41, 40, 39, 38, 7, 6, 5, 4, 3, 2, 1, 0};
const char DATA[] = {17, 16, 15, 14, 13, 12, 11, 10};
#define CLOCK 18
#define READ_WRITE 8
#define SYNC 9
#define VA 19

void setup() {
  for (int n = 0; n < 16; n += 1) {
    pinMode(ADDR[n], INPUT);
  }
  for (int n = 0; n < 8; n += 1) {
    pinMode(DATA[n], INPUT);
  }
  pinMode(CLOCK, OUTPUT);
  pinMode(READ_WRITE, INPUT);
  pinMode(SYNC, INPUT);
  pinMode(VA, INPUT);

  // clock is inverted on the breadboard
  //attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, FALLING);
  
  Serial.begin(57600);
}

bool stopped = false;

void onClock() {
  char output[19];

  unsigned int bank = 0;
  for (int n = 0; n < 8; n += 1) {
    int bit = digitalRead(ADDR[n]) ? 0 : 1;
    Serial.print(bit);
    bank = (bank << 1) + bit;
  }
  
  Serial.print(" ");

  unsigned int address = 0;
  for (int n = 8; n < 24; n += 1) {
    int bit = digitalRead(ADDR[n]) ? 1 : 0;
    Serial.print(bit);
    address = (address << 1) + bit;
  }
  
  Serial.print("   ");
  
  unsigned int data = 0;
  for (int n = 0; n < 8; n += 1) {
    int bit = digitalRead(DATA[n]) ? 1 : 0;
    Serial.print(bit);
    data = (data << 1) + bit;
  }

  if (data == 0xCB && digitalRead(SYNC)) {
    while(1);
  }

  if (digitalRead(VA)) {
    sprintf(output, "   %02x %04x  %c %02x %c", bank, address, digitalRead(READ_WRITE) ? 'r' : 'W', data, digitalRead(SYNC) ? '*' : ' ');
  } else {
    sprintf(output, "   -- ----  - --");
  }
  Serial.println(output);  
}

void loop() {
  // clock is inverted on the breadboard
  digitalWrite(CLOCK, 1);
  digitalWrite(CLOCK, 0);

  // wait 125ns for the ROM to output its data, each nop has a 62.5ns delay
  __asm__("nop\n\t");
  __asm__("nop\n\t");

  if (!stopped) {
    onClock();
  }
}
