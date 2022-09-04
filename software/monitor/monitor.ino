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
  pinMode(CLOCK_EN, OUTPUT);;
  
  Serial.begin(57600);
}

void print_byte_in_binary(byte x, bool va) {
  for (int i = 0; i < 8; i++) {
    Serial.print(va ? (x & 10000000 ? "1" : "0") : "-");
    x = x << 1;
  }
}

bool tracingEnabled = false;

void startTracing() {
  tracingEnabled = true;
  
  digitalWrite(CLOCK_EN, 1); // enable teensy clock
  __asm__("nop\n\t");        // Wait 62.5ns for main clock to be tri-stated
  digitalWrite(CLOCK_IN, 0); // make sure it starts with 0
  pinMode(CLOCK_IN, OUTPUT);
}

void stopTracing() {
  tracingEnabled = false;
  
  pinMode(CLOCK_IN, INPUT);  // tri-state the Teensy clock pin
  __asm__("nop\n\t");        // Wait 62.5ns for pin to be tri-stated
  digitalWrite(CLOCK_EN, 0); // enable main clock
}

void trace() {
  digitalWrite(CLOCK_IN, 1);

  // wait 125ns for the ROM to output its data, each nop has a 62.5ns delay
  __asm__("nop\n\t");
  __asm__("nop\n\t");

  byte bank      = PINB;
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

  char output[19];
  if (va) {
    sprintf(output, "%02x %02x%02x  %c %02x %c", bank, address_h, address_l, rw ? 'r' : 'W', data, sync ? '*' : ' ');
  } else {
    sprintf(output, "-- ----  - --");
  }
  Serial.println(output); 
  
  digitalWrite(CLOCK_IN, 0);
}

// blockingSerialRead blocks until data is available on the Serial port
byte blockingSerialRead() {
  while (Serial.available() == 0) { }
  return Serial.read();
}

// hexDigitToNumber converts a ASCII digit in 0..9, A..F to the corresponding number
byte hexDigitToNumber(byte hexDigit) {
  return (hexDigit >= 'A') ? hexDigit - 'A' + 10 : hexDigit - '0';
}

// readHexAsByte does two blocking reads from the Serial port, 
//   and interprets the result as the hexadecimal representation of a byte
byte readHexAsByte() {
  byte hn = hexDigitToNumber(blockingSerialRead());
  byte ln = hexDigitToNumber(blockingSerialRead());

  return hn << 4 | ln;
}

// printByteAsHex prints to Serial the hexadecimal representation of a byte, with leading zero
void printByteAsHex(byte b) {
  if (b < 16) {
    Serial.print('0');
  }
  Serial.print(b, HEX);
}

void handleProgramming() {
  while (true) { 
    // read intel hex header
    byte count = readHexAsByte();
    byte addr_h = readHexAsByte();
    byte addr_l = readHexAsByte();
    byte type = readHexAsByte();
    byte receiveCksum = count + addr_h  + addr_l + type;
  
    switch (type) {
      case 0x00: {
        // allocate buffer so we can grab the data, verify the checksum, and only then process it
        byte buffer[256];
        
        // Data record
        for (int i=0; i<count; i+=1) {
          buffer[i] = readHexAsByte();
          receiveCksum += buffer[i];
        }
      
        // checksum is after the data bytes
        byte checksum = readHexAsByte();
        if (byte(receiveCksum + checksum) != 0) {
          Serial.println("Invalid checksum on data record");
          break;
        }

        // TODO:  do something with the data
        for (int i=0; i<count; i+=1) {
          printByteAsHex(buffer[i]);
        }
        Serial.println("");
        
        break;
      }
      case 0x01: {
        // End of file, stop programming
        // empty checksum byte from buffer
        readHexAsByte();
        return;
      }
      default: {
        // unsupported record type
        Serial.print("Unsupported record type received: ");
        Serial.println(type, HEX);
        break;
      }
    }
  
    // consume everything before the start of a new packet (CR, LF, spaces...)
    byte start = 0;
    while (start != ':') {
      start = blockingSerialRead();
    }
  }
}

void loop() {
  if (Serial.available() > 0) {
    byte incomingByte = Serial.read();
    switch (incomingByte) {
      case ':':
        // start of an Intel HEX file, begin programming EEPROM
        handleProgramming();
        break;
      case 't':
        // enter trace mode
        startTracing();
        break;
      case 'q':
        // stop trace mode
        stopTracing();
        break;
      case ' ':
      case '\t':
      case '\r':
      case '\n':
        // do nothing for spaces
        break; 
      default:
        // unsupported character
        Serial.print("Unsupported character received: ");
        Serial.println(incomingByte, HEX);
        break;
    }
  }
    
  // Serial will be true if Serial Monitor is opened on the computer
  // This only works on Teensy and Arduino boards with native USB (Leonardo, Micro...), and indicates whether or not the USB CDC serial connection is open
  // On boards with separate USB interface, this always return true (eg. Uno, Nano, Mini, Mega)
  if (Serial) {
    if (tracingEnabled) {
      trace();
    }
  } else {
    if (tracingEnabled) {
      stopTracing();
    }
  }
}
