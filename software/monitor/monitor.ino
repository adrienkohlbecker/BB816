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

void print_byte_in_binary(byte x) {
  for (int i = 0; i < 8; i++) {
    Serial.print(x & 1 ? "1" : "0");
    x = x >> 1; 
  }
}

void onClock() {
  char output[19];

  byte bank = ~PINB;
  byte address_h = PINF;
  byte address_l = PIND;
  byte data = PINC;
  byte ctrl = PINE;

  bool va   = ((ctrl >> 7) & 1) > 0;
  bool sync = ((ctrl >> 1) & 1) > 0;
  bool rw   = ((ctrl >> 0) & 1) > 0;

  print_byte_in_binary(bank);
  Serial.print(" ");
  print_byte_in_binary(address_h);
  print_byte_in_binary(address_l);
  Serial.print("   ");
  print_byte_in_binary(data);

  if (va) {
    sprintf(output, "%02x %02x%02x  %c %02x %c", bank, address_h, address_l, rw ? 'r' : 'W', data, sync ? '*' : ' ');
  } else {
    sprintf(output, "-- ----  - --");
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
