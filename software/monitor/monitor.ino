const char ADDR[] = {27, 26, 25, 24, 23, 22, 21, 20, 45, 44, 43, 42, 41, 40, 39, 38, 35, 34, 33, 32, 31, 30, 29, 28};
const char DATA[] = {17, 16, 15, 14, 13, 12, 11, 10};
#define CLOCK_IN 18
#define CLOCK_EN 6
#define READ_WRITE 8
#define SYNC 9
#define VA 19

void setup() {
  for (int n = 0; n < 24; n += 1) {
    pinMode(ADDR[n], INPUT);
  }
  for (int n = 0; n < 8; n += 1) {
    pinMode(DATA[n], INPUT);
  }
  pinMode(CLOCK_IN, INPUT);
  pinMode(READ_WRITE, INPUT);
  pinMode(SYNC, INPUT);
  pinMode(VA, INPUT);

  digitalWrite(CLOCK_EN, 0);
  pinMode(CLOCK_EN, OUTPUT);

  //attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);
  
  Serial.begin(57600);
}

void print_byte_in_binary(byte x, bool va) {
  for (int i = 0; i < 8; i++) {
    Serial.print(va ? (x & 10000000 ? "1" : "0") : "-");
    x = x << 1; 
  }
}

void onClock() {
  char output[19];

  byte bank      = ~PINB;
  byte address_h = PINF;
  byte address_l = PINA;
  byte data      = PINC;
  byte ctrl      = PINE;

  bool va   = ((ctrl >> 7) & 1) > 0;
  bool sync = ((ctrl >> 1) & 1) > 0;
  bool rw   = ((ctrl >> 0) & 1) > 0;

  print_byte_in_binary(bank, va);
  Serial.print(" ");
  print_byte_in_binary(address_h, va);
  print_byte_in_binary(address_l, va);
  Serial.print(" ");
  print_byte_in_binary(data, va);
  Serial.print("   ");

  if (va) {
    sprintf(output, "%02x %02x%02x  %c %02x %c", bank, address_h, address_l, rw ? 'r' : 'W', data, sync ? '*' : ' ');
  } else {
    sprintf(output, "-- ----  - --");
  }
  Serial.println(output);  
}

void loop() {
  // Serial will be true if Serial Monitor is opened on the computer
  // this only works on Teensy, Arduino boards always return true (except the Due?).
  if (Serial) { 
    digitalWrite(CLOCK_EN, 1); // enable teensy clock
    __asm__("nop\n\t");        // Wait 62.5ns for main clock to be tri-stated
    pinMode(CLOCK_IN, OUTPUT);
 
    digitalWrite(CLOCK_IN, 0);
    digitalWrite(CLOCK_IN, 1);
    
    // wait 125ns for the ROM to output its data, each nop has a 62.5ns delay
    __asm__("nop\n\t");
    __asm__("nop\n\t");

    onClock();
  } else {
    digitalWrite(CLOCK_IN, 0); // make sure it restarts with 0
    pinMode(CLOCK_IN, INPUT);  // tri-state the Teensy clock pin
    __asm__("nop\n\t");        // Wait 62.5ns for pin to be tri-stated
    digitalWrite(CLOCK_EN, 0); // enable main clock
  }

}
