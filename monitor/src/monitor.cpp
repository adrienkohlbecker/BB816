#include <Arduino.h>

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
#define RD 3

// Whether to output the address bus and data bus in binary as well as hexadecimals
bool BINARY_TRACE = false;

// List of instruction mnemonics, index is the opcode
const char *mnemonics[] = {
  "BRK",
  "ORA (dp,X)",
  "COP #const",
  "ORA sr,S",
  "TSB dp",
  "ORA dp",
  "ASL dp",
  "ORA [dp]",
  "PHP",
  "ORA #const",
  "ASL A",
  "PHD",
  "TSB addr",
  "ORA addr",
  "ASL addr",
  "ORA long",
  "BPL nearlabel",
  "ORA (dp),Y",
  "ORA (dp)",
  "ORA (sr,S),Y",
  "TRB dp",
  "ORA dp,X",
  "ASL dp,X",
  "ORA [dp],Y",
  "CLC",
  "ORA addr,Y",
  "INC A",
  "TCS",
  "TRB addr",
  "ORA addr,X",
  "ASL addr,X",
  "ORA long,X",
  "JSR addr",
  "AND (dp,X)",
  "JSR long",
  "AND sr,S",
  "BIT dp",
  "AND dp",
  "ROL dp",
  "AND [dp]",
  "PLP",
  "AND #const",
  "ROL A",
  "PLD",
  "BIT addr",
  "AND addr",
  "ROL addr",
  "AND long",
  "BMI nearlabel",
  "AND (dp),Y",
  "AND (dp)",
  "AND (sr,S),Y",
  "BIT dp,X",
  "AND dp,X",
  "ROL dp,X",
  "AND [dp],Y",
  "SEC",
  "AND addr,Y",
  "DEC A",
  "TSC",
  "BIT addr,X",
  "AND addr,X",
  "ROL addr,X",
  "AND long,X",
  "RTI",
  "EOR (dp,X)",
  "WDM",
  "EOR sr,S",
  "MVP srcbk,destbk",
  "EOR dp",
  "LSR dp",
  "EOR [dp]",
  "PHA",
  "EOR #const",
  "LSR A",
  "PHK",
  "JMP addr",
  "EOR addr",
  "LSR addr",
  "EOR long",
  "BVC nearlabel",
  "EOR (dp),Y",
  "EOR (dp)",
  "EOR (sr,S),Y",
  "MVN srcbk,destbk",
  "EOR dp,X",
  "LSR dp,X",
  "EOR [dp],Y",
  "CLI",
  "EOR addr,Y",
  "PHY",
  "TCD",
  "JMP long",
  "EOR addr,X",
  "LSR addr,X",
  "EOR long,X",
  "RTS",
  "ADC (dp,X)",
  "PER label",
  "ADC sr,S",
  "STZ dp",
  "ADC dp",
  "ROR dp",
  "ADC [dp]",
  "PLA",
  "ADC #const",
  "ROR A",
  "RTL",
  "JMP (addr)",
  "ADC addr",
  "ROR addr",
  "ADC long",
  "BVS nearlabel",
  "ADC ( dp),Y",
  "ADC (dp)",
  "ADC (sr,S),Y",
  "STZ dp,X",
  "ADC dp,X",
  "ROR dp,X",
  "ADC [dp],Y",
  "SEI",
  "ADC addr,Y",
  "PLY",
  "TDC",
  "JMP (addr,X)",
  "ADC addr,X",
  "ROR addr,X",
  "ADC long,X",
  "BRA nearlabel",
  "STA (dp,X)",
  "BRL label",
  "STA sr,S",
  "STY dp",
  "STA dp",
  "STX dp",
  "STA [dp]",
  "DEY",
  "BIT #const",
  "TXA",
  "PHB",
  "STY addr",
  "STA addr",
  "STX addr",
  "STA long",
  "BCC nearlabel",
  "STA (dp),Y",
  "STA (dp)",
  "STA (sr,S),Y",
  "STY dp,X",
  "STA dp,X",
  "STX dp,Y",
  "STA [dp],Y",
  "TYA",
  "STA addr,Y",
  "TXS",
  "TXY",
  "STZ addr",
  "STA addr,X",
  "STZ addr,X",
  "STA long,X",
  "LDY #const",
  "LDA (dp,X)",
  "LDX #const",
  "LDA sr,S",
  "LDY dp",
  "LDA dp",
  "LDX dp",
  "LDA [dp]",
  "TAY",
  "LDA #const",
  "TAX",
  "PLB",
  "LDY addr",
  "LDA addr",
  "LDX addr",
  "LDA long",
  "BCS nearlabel",
  "LDA (dp),Y",
  "LDA (dp)",
  "LDA (sr,S),Y",
  "LDY dp,X",
  "LDA dp,X",
  "LDX dp,Y",
  "LDA [dp],Y",
  "CLV",
  "LDA addr,Y",
  "TSX",
  "TYX",
  "LDY addr,X",
  "LDA addr,X",
  "LDX addr,Y",
  "LDA long,X",
  "CPY #const",
  "CMP (dp,X)",
  "REP #const",
  "CMP sr,S",
  "CPY dp",
  "CMP dp",
  "DEC dp",
  "CMP [dp]",
  "INY",
  "CMP #const",
  "DEX",
  "WAI",
  "CPY addr",
  "CMP addr",
  "DEC addr",
  "CMP long",
  "BNE nearlabel",
  "CMP (dp),Y",
  "CMP (dp)",
  "CMP (sr,S),Y",
  "PEI (dp)",
  "CMP dp,X",
  "DEC dp,X",
  "CMP [dp],Y",
  "CLD",
  "CMP addr,Y",
  "PHX",
  "STP",
  "JMP [addr]",
  "CMP addr,X",
  "DEC addr,X",
  "CMP long,X",
  "CPX #const",
  "SBC (dp,X)",
  "SEP #const",
  "SBC sr,S",
  "CPX dp",
  "SBC dp",
  "INC dp",
  "SBC [dp]",
  "INX",
  "SBC #const",
  "NOP",
  "XBA",
  "CPX addr",
  "SBC addr",
  "INC addr",
  "SBC long",
  "BEQ nearlabel",
  "SBC (dp),Y",
  "SBC (dp)",
  "SBC (sr,S),Y",
  "PEA addr",
  "SBC dp,X",
  "INC dp,X",
  "SBC [dp],Y",
  "SED",
  "SBC addr,Y",
  "PLX",
  "XCE",
  "JSR (addr,X))",
  "SBC addr,X",
  "INC addr,X",
  "SBC long,X"
};

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
  pinMode(RD, INPUT);

  Serial.begin(115200);
}

void printByteAsBinary(byte x) {
  for (int i = 0; i < 8; i++) {
    Serial.print(x & 10000000 ? "1" : "0");
    x = x << 1;
  }
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

bool tracingEnabled = false;

byte breakpoint[3];
bool hasBreakpoint = false;
bool breaking = false;

void startTracing() {
  if (tracingEnabled) { return; }

  tracingEnabled = true;
  breaking = false;
  Serial.println("Tracing...");

  digitalWrite(CLOCK_EN, 1); // enable teensy clock
  pinMode(CLOCK_EN, OUTPUT);
  __asm__("nop\n\t");        // Wait 62.5ns for main clock to be tri-stated
  digitalWrite(CLOCK_SRC, 0); // make sure it starts with 0
  pinMode(CLOCK_SRC, OUTPUT);
}

void stopTracing() {
  if (!tracingEnabled) { return; }

  tracingEnabled = false;
  breaking = false;
  Serial.println("Stopped tracing!");

  digitalWrite(CLOCK_SRC, 0);
  pinMode(CLOCK_SRC, INPUT);  // tri-state the Teensy clock pin
  __asm__("nop\n\t");        // Wait 62.5ns for pin to be tri-stated
  digitalWrite(CLOCK_EN, 0); // enable main clock
  pinMode(CLOCK_EN, INPUT);
}

inline void trace() {
  digitalWrite(CLOCK_SRC, 0);
  digitalWrite(CLOCK_SRC, 1);

  // wait 125ns for the ROM to output its data, each nop has a 62.5ns delay
  __asm__("nop\n\t");
  __asm__("nop\n\t");

  byte bank      = PIN_BANK;
  byte address_h = PIN_ADDR_H;
  byte address_l = PIN_ADDR_L;
  byte data      = PIN_DATA;
  byte ctrl      = PIN_CTRL;

  bool va   = (ctrl & (1 << 7)) > 0;
  bool sync = (ctrl & (1 << 1)) > 0;
  bool rw   = (ctrl & (1 << 0)) > 0;

  if (va) {
    if (BINARY_TRACE) {
      printByteAsBinary(bank);
      Serial.print(" ");
      printByteAsBinary(address_h);
      printByteAsBinary(address_l);
      Serial.print(" ");
      printByteAsBinary(data);
      Serial.print("   ");
    }

    printByteAsHex(bank);
    Serial.print(" ");
    printByteAsHex(address_h);
    printByteAsHex(address_l);
    Serial.print(rw ? " r " : " W ");
    printByteAsHex(data);

    if (sync) {
      Serial.print("  ");
      Serial.print(mnemonics[data]);
    }

    Serial.println("");
  } else {
    if (BINARY_TRACE) {
       Serial.print("-------- ---------------- --------   ");
    }
    Serial.println("-- ---- - --");
  }

  if (sync && hasBreakpoint && bank == breakpoint[0] && address_h == breakpoint[1] && address_l == breakpoint[2]) {
    Serial.println("break!");
    breaking = true;
  }
}

void step() {
  if (!breaking) {
    breaking = true;
  } else {
    trace();
  }
}

void resumeTrace() {
  if (!breaking) { return; }

  breaking = false;
}

// blockingSerialRead blocks until data is available on the Serial port
byte blockingSerialRead() {
  while (Serial.available() == 0) { }
  return Serial.read();
}

// hexDigitToNumber converts a ASCII digit in 0..9, A..F and a..f to the corresponding number
byte hexDigitToNumber(byte hexDigit) {
  return (hexDigit >= 'A') ? (hexDigit & 0b11011111) - 'A' + 10 : hexDigit - '0';
}

// readHexAsByte does two blocking reads from the Serial port,
//   and interprets the result as the hexadecimal representation of a byte
byte readHexAsByte() {
  byte hn = hexDigitToNumber(blockingSerialRead());
  byte ln = hexDigitToNumber(blockingSerialRead());

  return hn << 4 | ln;
}

byte readHexAsByteWithEcho() {
  byte digit;
  digit = blockingSerialRead();
  Serial.write(digit);
  byte hn = hexDigitToNumber(digit);
  digit = blockingSerialRead();
  Serial.write(digit);
  byte ln = hexDigitToNumber(digit);

  return hn << 4 | ln;
}


void resetComputer() {
  Serial.println("Reset");
  digitalWrite(MR, 0);
  pinMode(MR, OUTPUT);
  __asm__("nop\n\t");
  digitalWrite(MR, 1);
  pinMode(MR, INPUT);
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
  // wait 62.5ns for address decoding to happen
  __asm__("nop\n\t");
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

void startReadFromROM() {
  // Set data to input
  DDR_DATA = 0b00000000;

  // Set RD to output
  digitalWrite(RD, 1);
  pinMode(RD, OUTPUT);
}

void endReadFromROM() {
  // Set RD to input
  digitalWrite(RD, 1);
  pinMode(RD, INPUT);

  // Set data to output
  DDR_DATA = 0b11111111;
}

byte readByteAtAddress(word addr) {
  // Set address pins
  PORT_BANK = 0;
  PORT_ADDR_H = highByte(addr);
  PORT_ADDR_L = lowByte(addr);

  // Start RD pulse
  digitalWrite(RD, 0);
  // wait 187.5ns to satisfy data access time + address decoding time
  __asm__("nop\n\t");
  __asm__("nop\n\t");
  __asm__("nop\n\t");
  // Read data
  byte readData = PIN_DATA;
  // Stop RD pulse
  digitalWrite(RD, 1);
  // wait 62.5ns to satisfy tDF
  __asm__("nop\n\t");

  return readData;
}

void checkToggleBit(word addr) {
  byte newData = readByteAtAddress(addr) & 0b01000000;
  byte previousData = !newData;

  // Wait for data to be valid
  while(newData != previousData) {
    previousData = newData;
    newData = readByteAtAddress(addr) & 0b01000000;

    // TODO: figure out why this is needed
    delayMicroseconds(200);
  }
}

void enableWriteProtection() {
  programByteAtAddress(0x5555 + 0x8000, 0xAA);
  programByteAtAddress(0x2AAA + 0x8000, 0x55);
  programByteAtAddress(0x5555 + 0x8000, 0xA0);

  delay(10); // ensure the write cycle ends (tWC)
}

void disableWriteProtection() {
  programByteAtAddress(0x5555 + 0x8000, 0xAA);
  programByteAtAddress(0x2AAA + 0x8000, 0x55);
  programByteAtAddress(0x5555 + 0x8000, 0x80);
  programByteAtAddress(0x5555 + 0x8000, 0xAA);
  programByteAtAddress(0x2AAA + 0x8000, 0x55);
  programByteAtAddress(0x5555 + 0x8000, 0x20);

  delay(10); // ensure the write cycle ends (tWC)
}

void handleProgramming() {
  Serial.println("Programming...");
  startProgramming();
  disableWriteProtection();

  bool hasEncounteredError = false;

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
        byte buffer[64];

        // page write mode only supports 64 bytes in a single operation
        if (count > 64) {
          hasEncounteredError = true;
          Serial.print("invalid packet with more than 64 bytes, size=");
          Serial.println(count, DEC);
          break;
        }

        // Data record
        for (int i=0; i<count; i+=1) {
          buffer[i] = readHexAsByte();
          receiveCksum += buffer[i];
        }

        // checksum is after the data bytes
        byte checksum = readHexAsByte();
        if (byte(receiveCksum + checksum) != 0) {
          hasEncounteredError = true;
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

        // setup ROM for reading
        startReadFromROM();

        // poll for end of write operation
        checkToggleBit(addr+count-1);

        // verify that all bytes have been written correctly
        for (int i=0; i<count; i+=1) {
          byte readData = readByteAtAddress(addr+i);
          if (buffer[i] != readData) {
            hasEncounteredError = true;
            Serial.print("failed verification at address=");
            printWordAsHex(addr+i);
            Serial.print(" expected=");
            printByteAsHex(buffer[i]);
            Serial.print(" read=");
            printByteAsHex(readData);
            Serial.println("");
            break;
          }
        }

        // Finish reading from ROM
        endReadFromROM();

        break;
      }
      case 0x01: {
        // End of file, stop programming

        // empty checksum byte from buffer
        readHexAsByte();

        if (hasEncounteredError) {
          Serial.println("Errors during programming!");
        } else {
          Serial.println("Done!");
        }

        enableWriteProtection();
        endProgramming();
        return;
      }
      default: {
        // unsupported record type
        hasEncounteredError = true;
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

void setBreakpoint() {
  Serial.print("Breakpoint: ");
  hasBreakpoint = true;
  breakpoint[0] = readHexAsByteWithEcho();
  Serial.print(" ");
  breakpoint[1] = readHexAsByteWithEcho();
  Serial.print(" ");
  breakpoint[2] = readHexAsByteWithEcho();
  Serial.println("");
}

void removeBreakpoint() {
  Serial.println("Cleared breakpoint");
  hasBreakpoint = false;
  breaking = false;
}

void toggleBinaryTrace() {
  BINARY_TRACE = !BINARY_TRACE;
}

bool welcome = false;

void loop() {
  // Serial will be true if Serial Monitor is opened on the computer
  // This only works on Teensy and Arduino boards with native USB (Leonardo, Micro...), and indicates whether or not the USB CDC serial connection is open
  // On boards with separate USB interface, this always return true (eg. Uno, Nano, Mini, Mega)
  if (!Serial) {
    if (welcome) { welcome = false; }
    if (tracingEnabled) { stopTracing(); }
    return;
  }

  if (!welcome) {
    // Print welcome message
    welcome = true;
    delay(200);
    Serial.println("Teensy monitor for BB816 computer");
    Serial.println("Help: `t` to trace. `q` to stop trace. `r` to reset the computer.");
    Serial.println("      `i` to toggle binary trace.");
    Serial.println("      `b` to set a breakpoint. `d` to delete the breakpoint.");
    Serial.println("      when breaking, `s` to step one clock cycle. `c` to resume the clock.");
    Serial.println("");
  }

  if (Serial.available() > 0) {
    byte incomingByte = Serial.read();
    switch (incomingByte) {
      case ':':
        // start of an Intel HEX file, begin programming EEPROM
        handleProgramming();
        break;
      case 'r':
        // reset the computer
        resetComputer();
        break;
      case 't':
        // enter trace mode
        startTracing();
        break;
      case 'q':
        // stop trace mode
        stopTracing();
        break;
      case 'i':
        // toggle binary trace
        toggleBinaryTrace();
        break;
      case 'b':
        // set breakpoint
        setBreakpoint();
        break;
      case 'd':
        // set breakpoint
        removeBreakpoint();
        break;
      case 's':
        // step clock
        step();
        break;
      case 'c':
        // continue clock
        resumeTrace();
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

  if (tracingEnabled && !breaking) {
    trace();
  }
}
