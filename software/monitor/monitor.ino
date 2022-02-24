const char ADDR[] = {25, 24, 23, 22, 21, 20, 19, 18, 38, 39, 40, 41, 42, 43, 44, 45, 2, 3, 4, 5, 6, 7, 8, 9};
const char DATA[] = {10, 11, 12, 13, 14, 15, 16, 17};
#define CLOCK 0
#define READ_WRITE 1
#define SYNC 27
#define VA 26

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

  //attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);
  
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

  if (digitalRead(VA)) {
    sprintf(output, "   %02x %04x  %c %02x %c", bank, address, digitalRead(READ_WRITE) ? 'r' : 'W', data, digitalRead(SYNC) ? '*' : ' ');
  } else {
    sprintf(output, "   -- ----  - --");
  }
  Serial.println(output);  
}

void loop() {
  digitalWrite(CLOCK, 0);
  digitalWrite(CLOCK, 1);

  // wait 125ns for the ROM to output its data, each nop has a 62.5ns delay
  __asm__("nop\n\t");
  __asm__("nop\n\t");

  if (!stopped) {
    onClock();
  }
}
