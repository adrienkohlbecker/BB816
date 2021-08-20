# 65C816
A homebrew computer based on the 65C816 processor

## Schematic

[![Schematic](./hardware/65C816.png)](./hardware/65C816.png)

## BOM

**Component Count:** 20

| Refs | Qty | Component | Description |
| ----- | --- | ---- | ----------- |
| C1 | 1 | 220u | Polarized capacitor, small symbol |
| C2, C3 | 2 | 10u | Polarized capacitor, small symbol |
| C4, C5, C6, C7 | 4 | 100n | Unpolarized capacitor, small symbol |
| D1 | 1 | POWER | Light emitting diode, small symbol |
| J1 | 1 | POWER | Generic connector, single row, 01x02
| R1 | 1 | 220 | Resistor, small symbol |
| RN1, RN2, RN3, RN4, RN5, RN6 | 6 | 10k | 8 resistor network, star topology, bussed resistors, small symbol |
| U1 | 1 | 74AC00 | quad 2-input NAND gate |
| U2 | 1 | W65C816SxP | W65C816S 8/16-bit CMOS General Purpose Microprocessor, DIP-40 |
| U3 | 1 | 74AC245 | Octal BUS Transceivers, 3-State outputs |
| U4 | 1 | 74AC573 | 8-bit Latch 3-state outputs |

### Used in previous videos

| Refs | Qty | Component | Description |
| ----- | --- | ---- | ----------- |
| U* | 1 | 74AC04 | hex inverter |
