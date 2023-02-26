from platformio.public import DeviceMonitorFilterBase
import unittest

class Bus(DeviceMonitorFilterBase):
#class Bus():
  NAME = "bus"

  # Whether to output the address bus and data bus in binary as well as hexadecimals
  BINARY_TRACE = False

  def __call__(self):
    self.buffer = ""
    return self

  def __init__(self, *args, **kwargs):
    self.buffer = ""
    super().__init__(*args, **kwargs)

  # This filter processes all the incoming bytes through the monitor's serial link.
  # Most of the bytes are passed through, except lines starting with 0x11 (ASCII's DC1 character)
  # These lines are special "trace" lines, that contain bytes for the values of the address bus, data bus, and control lines of the computer
  # They are processed independently, and the result is forwarded to the terminal instead of them.
  #
  # Calls to rx() can happen in the middle of lines, with incomplete data. If we detect that we're currently receiving a trace line,
  # and it is split over multiple rx() calls, we buffer the incoming bytes until the line is complete.
  def rx(self, text):
    first = 0
    last = 0

    while True:
      # did we reach the end of the text
      if last == len(text):
        return text

      idx = text.find("\n", last)
      # if the remainder of the text contains no new line
      if idx == -1:
        # if the buffer starts with 0x11, we're building a trace line, add text to buffer and return the text up to here
        if self.buffer.startswith(chr(0x11)) and len(self.buffer) < 4096:
          self.buffer += text[last:]
          return text[:last]
        # if the remainder starts with 0x11, we're starting a trace line
        elif text[last] == chr(0x11):
          self.buffer += text[last:]
          return text[:last]
        # else, we're reading a non trace line, we can just return the rest of the string
        else:
          return text
      # if we did find a new line
      else:
        line = text[last:idx]
        # if we were buffering a trace line, empty buffer
        if len(self.buffer) > 0:
          line = self.buffer + line
          self.buffer = ""

        first = last
        last = idx + 1

        # if it is not a trace line, we don't touch it
        if not line.startswith(chr(0x11)):
          continue

        # incomplete line, it probably had a \n as data byte
        if len(line) < 6:
          # print('===')
          # print(f'{[c for c in text]}')
          # print(f'{[c for c in line]}')
          self.buffer = line + "\n"
          text = text[: first] + text[last :]
          # print(f'{[c for c in text]}')
          # print(first)
          # print(last)
          last -= last - first
          # print(last)
          continue

        # replace the trace line with the processed text
        trace = self.process_line(line)
        if len(trace) != 0:
          text = text[: first] + trace + text[last-1 :]
          last += len(trace)-len(line)

    return text

  def tx(self, text):
    return text

  def process_line(self, line):
    if len(line) != 6:
      print(f'{[c for c in line]}')
      raise Exception("trace line should be 6 bytes")

    bank =   ord(line[1])
    addr_h = ord(line[2])
    addr_l = ord(line[3])
    data =   ord(line[4])
    ctrl =   ord(line[5])

    va   = (ctrl & (1 << 7)) > 0
    sync = (ctrl & (1 << 1)) > 0
    rw   = (ctrl & (1 << 0)) > 0

    result = ""

    if va:
      if self.BINARY_TRACE:
        result += "{:08b} {:08b}{:08b} {:08b}   ".format(bank, addr_h, addr_l, data)
      result += "{:02x} {:02x}{:02x} {} {:02x}  {}".format(bank, addr_h, addr_l, "r" if rw else "W", data, mnemonics[data] if sync else "")
    else:
      if self.BINARY_TRACE:
        result += "-------- ---------------- --------   "
      result += "-- ---- - --"

    return result

class TestBus(unittest.TestCase):
  def setUp(self):
    self.b = Bus()

  def test_simple(self):
    t = self.b.rx("abc")
    self.assertEqual(t, "abc")
    self.assertEqual(self.b.buffer, "")
    t = self.b.rx("def")
    self.assertEqual(t, "def")
    self.assertEqual(self.b.buffer, "")
    t = self.b.rx("\nghi")
    self.assertEqual(t, "\nghi")
    self.assertEqual(self.b.buffer, "")
    t = self.b.rx("jk\n\nlmn\n")
    self.assertEqual(t, "jk\n\nlmn\n")
    self.assertEqual(self.b.buffer, "")

  def test_edgecases(self):
    t = self.b.rx("")
    self.assertEqual(t, "")
    self.assertEqual(self.b.buffer, "")
    t = self.b.rx("\n")
    self.assertEqual(t, "\n")
    self.assertEqual(self.b.buffer, "")

  def test_trace(self):
    t = self.b.rx("\x11trace\n")
    self.assertEqual(t, "-- ---- - --\n")
    self.assertEqual(self.b.buffer, "")

  def test_trace_split(self):
    t = self.b.rx("\x11tr")
    self.assertEqual(t, "")
    self.assertEqual(self.b.buffer, "\x11tr")
    t = self.b.rx("ace")
    self.assertEqual(t, "")
    self.assertEqual(self.b.buffer, "\x11trace")
    t = self.b.rx("\n")
    self.assertEqual(t, "-- ---- - --\n")
    self.assertEqual(self.b.buffer, "")

  def test_trace_with_Ox0A_byte(self):
    t = self.b.rx("foo\n\x11tr\nce\nbar\n")
    self.assertEqual(t, "foo\n-- ---- - --\nbar\n")
    self.assertEqual(self.b.buffer, "")
    t = self.b.rx("\x11tr\n")
    self.assertEqual(t, "")
    self.assertEqual(self.b.buffer, "\x11tr\n")
    t = self.b.rx("ce")
    self.assertEqual(t, "")
    self.assertEqual(self.b.buffer, "\x11tr\nce")
    t = self.b.rx("\n")
    self.assertEqual(t, "-- ---- - --\n")
    self.assertEqual(self.b.buffer, "")

  def test_another_0x0A_byte(self):
    t = self.b.rx("\x11")
    self.assertEqual(t, "")
    self.assertEqual(self.b.buffer, "\x11")
    t = self.b.rx("\x00\x80\x13\nA\n")
    self.assertEqual(t, "-- ---- - --\n")
    self.assertEqual(self.b.buffer, "")

mnemonics = [
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
]

if __name__ == '__main__':
    unittest.main()
