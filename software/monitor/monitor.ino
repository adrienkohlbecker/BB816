#define DDR_BANK DDRB
#define PIN_BANK PINB
#define PORT_BANK PORTB
#define DDR_ADDR_H DDRF
#define PIN_ADDR_H PINF
#define PORT_ADDR_H PORTF
#define DDR_ADDR_L DDRA
#define PIN_ADDR_L PINA
#define PORT_ADDR_L PORTA
#define DDR_DATA DDRC
#define PIN_DATA PINC
#define PORT_DATA PORTC
#define DDR_CTRL DDRE
#define PIN_CTRL PINE
#define PORT_CTRL PORTE

#define CLOCK_SRC 18
#define CLOCK_EN 6
#define READ_WRITE 8
#define SYNC 9
#define VA 19
#define MR 5
#define BE 4
#define ROM_WE 7

void setup() {
  DDR_BANK = 0b00000000;
  DDR_ADDR_H = 0b00000000;
  DDR_ADDR_L = 0b00000000;
  DDR_DATA = 0b00000000;

  pinMode(CLOCK_SRC, INPUT);
  pinMode(CLOCK_EN, INPUT);
  pinMode(READ_WRITE, INPUT);
  pinMode(SYNC, INPUT);
  pinMode(VA, INPUT);
  pinMode(MR, INPUT);
  pinMode(BE, INPUT);
  pinMode(ROM_WE, INPUT);

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
  pinMode(CLOCK_EN, OUTPUT);
  __asm__("nop\n\t");        // Wait 62.5ns for main clock to be tri-stated
  digitalWrite(CLOCK_SRC, 0); // make sure it starts with 0
  pinMode(CLOCK_SRC, OUTPUT);
}

void stopTracing() {
  tracingEnabled = false;
  
  digitalWrite(CLOCK_SRC, 0); 
  pinMode(CLOCK_SRC, INPUT);  // tri-state the Teensy clock pin
  __asm__("nop\n\t");        // Wait 62.5ns for pin to be tri-stated
  digitalWrite(CLOCK_EN, 0); // enable main clock
  pinMode(CLOCK_EN, INPUT);
}

void trace() {
  digitalWrite(CLOCK_SRC, 1);

  // wait 125ns for the ROM to output its data, each nop has a 62.5ns delay
  __asm__("nop\n\t");
  __asm__("nop\n\t");

  byte bank      = PIN_BANK;
  byte address_h = PIN_ADDR_H;
  byte address_l = PIN_ADDR_L;
  byte data      = PIN_DATA;
  byte ctrl      = PIN_CTRL;

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
  
  digitalWrite(CLOCK_SRC, 0);
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

// printWordAsHex prints to Serial the hexadecimal representation of a byte, with leading zero
void printWordAsHex(word w) {
  printByteAsHex(highByte(w));
  printByteAsHex(lowByte(w));
}

void startProgramming() {
  digitalWrite(MR, 0); 
  pinMode(MR, OUTPUT);
  digitalWrite(BE, 0);
  pinMode(BE, OUTPUT);
  
  // wait 62.5ns for the CPU and glue logic buffers to be disabled
  __asm__("nop\n\t");
  // set address and data bus as outputs
  PORT_BANK = 0b00000000;
  PORT_ADDR_H = 0b00000000;
  PORT_ADDR_L = 0b00000000;
  PORT_DATA = 0b00000000;
  DDR_BANK = 0b11111111;
  DDR_ADDR_H = 0b11111111;
  DDR_ADDR_L = 0b11111111;
  DDR_DATA = 0b11111111;

  // Set ROM_WE to output
  digitalWrite(ROM_WE, 1);
  pinMode(ROM_WE, OUTPUT);
}

void endProgramming() {
  // Set ROM_WE to input
  digitalWrite(ROM_WE, 1);
  pinMode(ROM_WE, INPUT);
  
  // set address and data bus as inputs
  DDR_BANK = 0b00000000;
  DDR_ADDR_H = 0b00000000;
  DDR_ADDR_L = 0b00000000;
  DDR_DATA = 0b00000000;
  // wait 62.5ns for the Teensy buffers to be disabled
  __asm__("nop\n\t");
  
  digitalWrite(BE, 1);
  pinMode(BE, INPUT);
  // wait 62.5ns for the CPU and glue logic buffers to be enabled
  __asm__("nop\n\t");
  digitalWrite(MR, 1); 
  pinMode(MR, INPUT);
}

void programByteAtAddress(word addr, byte data) {
  // Set address pins
  PORT_BANK = 0;
  PORT_ADDR_H = highByte(addr);
  PORT_ADDR_L = lowByte(addr);
  // Start WE pulse
  digitalWrite(ROM_WE, 0);
  // Set data pins
  PORT_DATA = data;
  // wait 125ns to satisfy tDS and tWP
  __asm__("nop\n\t");
  __asm__("nop\n\t");
  // Stop WE pulse
  digitalWrite(ROM_WE, 1);
  // wait 62.5ns to satisfy tWPH
  __asm__("nop\n\t");
}

void handleProgramming() {
  startProgramming();
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
          Serial.print("Invalid checksum on data record, got ");
          printByteAsHex(checksum);
          Serial.print(" computed ");
          printByteAsHex(-receiveCksum);
          Serial.println("");
          break;
        }

        // base address offset
        word addr = word(addr_h, addr_l);
        // each successive byte is programmed at an incrementing address
        for (int i=0; i<count; i+=1) {
          programByteAtAddress(addr+i, buffer[i]);
        }
        
        break;
      }
      case 0x01: {
        // End of file, stop programming
        // empty checksum byte from buffer
        readHexAsByte();
        endProgramming();
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
