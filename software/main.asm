!cpu 65816
!initmem $ea

; Memory Map
;
; 0000 0000 0000 0000 0000 0000 - 0000 0000 1111 1111 1111 1111 | 000000 00FFFF | Bank 0 (see below)
; 1111 0000 0000 0000 0000 0000 - 1111 0111 1111 1111 1111 1111 | F00000 F7FFFF | Extended RAM
;
; Bank0:
;
; 0000 0000 0000 0000 - 0000 0000 1111 1111 | 0000 - 00FF | Direct page
; 0000 0001 0000 0000 - 0000 0001 1111 1111 | 0100 - 01FF | Stack
; 0000 0010 0000 0000 - 0111 1111 0111 1111 | 0200 - 7F7F | General Purpose RAM
; 0111 1111 1000 0000 - 0111 1111 1111 1111 | 7F80 - 7FFF | I/O
; 1000 0000 0000 0000 - 1111 1111 1111 1111 | 8000 - FFFF | ROM
;
; I/O:
;
; 0111 1111 1000 0000 - 0111 1111 1000 1111 | 7F80 - 7F8F | I/O #0 | 65C22 VIA
; 0111 1111 1001 0000 - 0111 1111 1001 1111 | 7F90 - 7F9F | I/O #1 | 65C51 ACIA
; 0111 1111 1010 0000 - 0111 1111 1010 1111 | 7FA0 - 7FAF | I/O #2
; 0111 1111 1011 0000 - 0111 1111 1011 1111 | 7FB0 - 7FBF | I/O #3
; 0111 1111 1100 0000 - 0111 1111 1100 1111 | 7FC0 - 7FCF | I/O #4
; 0111 1111 1101 0000 - 0111 1111 1101 1111 | 7FD0 - 7FDF | I/O #5
; 0111 1111 1110 0000 - 0111 1111 1110 1111 | 7FE0 - 7FEF | I/O #6
; 0111 1111 1111 0000 - 0111 1111 1111 1111 | 7FF0 - 7FFF | I/O #7

!address START_OF_ROM = $8000

!address IO_0 = $7F80
!address IO_1 = $7F90
!address IO_2 = $7FA0
!address IO_3 = $7FB0
!address IO_4 = $7FC0
!address IO_5 = $7FD0
!address IO_6 = $7FE0
!address IO_7 = $7FF0

// Constants

CPU_FLAG_CARRY       = 1 << 0
CPU_FLAG_ZERO        = 1 << 1
CPU_FLAG_IRQ_DISABLE = 1 << 2
CPU_FLAG_DECIMAL     = 1 << 3
CPU_FLAG_BREAK       = 1 << 4 ; Emulation mode
CPU_FLAG_INDEX_8BIT  = 1 << 4 ; Native mode
CPU_FLAG_MEMORY_8BIT = 1 << 5 ; Native mode
CPU_FLAG_OVERFLOW    = 1 << 6
CPU_FLAG_NEGATIVE    = 1 << 7

// IRQ handlers
!address vec_native_irq   = $00 // 2 bytes
!address vec_native_nmi   = $02 // 2 bytes
!address vec_native_abort = $04 // 2 bytes
!address vec_native_brk   = $06 // 2 bytes
!address vec_native_cop   = $08 // 2 bytes
!address vec_emu_irq      = $0A // 2 bytes
!address vec_emu_nmi      = $0C // 2 bytes
!address vec_emu_abort    = $0E // 2 bytes
!address vec_emu_brk      = $10 // 2 bytes
!address vec_emu_cop      = $12 // 2 bytes

*=START_OF_ROM

!source "lib/macros.asm"

reset:
  ; initialize stack pointer to 01FF
  ldx #$ff
  txs

  ; put CPU in native mode
  ; this is diagnostic number 1: If the Emulation LED turns off,
  ; it means the board able to read the reset vector, and execute the first few instructions.
  +cpu_native

  ; Diagnostic number 2
  ; checksum ourselves

  ; set registers to 16 bits (Set bits m and x to 0 in CPU status register)
  rep # %00110000
  !rl
  !al

  ldx # $7FFE
  lda # 0

- clc
  adc START_OF_ROM, x
  dex
  dex
  bpl -

  cmp # 0
  bne checksum_fail

  ; ### Diagnostic 3: Test bank0 RAM

  ; load into X the address of the end of RAM
  ldx #$7f7f
  dex ; align to 16 bits

  ; store 16 bits of data at X and X+1 and verify we read the same thing
- txa
  sta address($0),X ; direct page indexed
  cmp address($0),X
  bne memtest_fail

  ; decrement address
  dex
  dex

  ; continue until X=0
  bne -

  ; ### Diagnostic 4: Test extended RAM

  ldy # $f0 ; store bank number F0 into Y

  ; set indexes to 8 bits
-- sep #%00010000
	!rs

  phy
  plb ; pull value into Data Bank Register, effectively changing bank for all data accesses

  ; set indexes to 16 bits
  rep #%00010000
	!rl

  ldx #$ffff
  dex ; align to 16 bits

   ; store 16 bits of data at X and X+1 and verify we read the same thing
- txa
  sta address($0000),X ; absolute indexed
  cmp address($0000),X
  bne highmemtest_fail

  ; decrement address
  dex
  dex

  ; continue until X=0
  bne -

  ; increment Y
  iny
  cpy #$F8
  bne --

  ; set registers to 8 bits (Set bits m and x to 1 in CPU status register)
  sep # %00110000
  !rs
  !as

  ; reset data bank register
  ldy #0
  phy
  plb

  jmp kernel_init

checksum_fail:

  ; set registers to 8 bits (Set bits m and x to 1 in CPU status register)
  sep # %00110000
  !rs
  !as

  ; alternate E on with E off to signify ROM checksum error (200ms period)
  sec ; carry is set, emulation is off before this loop, so we can just repeat XCE to get toggling
- +delay_large_ms 200
  xce
  jmp -

memtest_fail:

  ; set registers to 8 bits (Set bits m and x to 1 in CPU status register)
  sep # %00110000
  !rs
  !as

  ; alternate E on with E off to signify low RAM error (one short 200ms, one long 400ms)
  sec ; carry is set, emulation is off before this loop, so we can just repeat XCE to get toggling
- +delay_large_ms 400
  xce
  +delay_large_ms 200
  xce
  +delay_large_ms 200
  xce
  +delay_large_ms 400
  xce
  jmp -

highmemtest_fail:

  ; set registers to 8 bits (Set bits m and x to 1 in CPU status register)
  sep # %00110000
  !rs
  !as

  ; alternate E on with E off to signify extended RAM error (two short 200ms, one long 400ms)
  sec ; carry is set, emulation is off before this loop, so we can just repeat XCE to get toggling
- +delay_large_ms 400
  xce
  +delay_large_ms 200
  xce
  +delay_large_ms 200
  xce
  +delay_large_ms 200
  xce
  +delay_large_ms 200
  xce
  +delay_large_ms 400
  xce
  jmp -

kernel_init:
  ; initialize devices
  jsr via_init
  jsr lcd_init
  jsr acia_init

  ; initialize interrupt vectors
  +m_16_bits
  lda # int(int_native_exit)
  sta vec_native_irq
  sta vec_native_nmi
  sta vec_native_abort
  sta vec_native_brk
  sta vec_native_cop
  lda # int(int_emu_exit)
  sta vec_emu_irq
  sta vec_emu_nmi
  sta vec_emu_abort
  sta vec_emu_brk
  sta vec_emu_cop
  +m_8_bits

  !source "prgm.asm"

  ; shouldn't be reached
  stp

!source "lib/via.asm"
!source "lib/lcd.asm"
!source "lib/acia.asm"

; Native mode interrupts

!address int_native_stack_offset_pbr = 12
!address int_native_stack_offset_pc  = 10
!address int_native_stack_offset_p   = 9
!address int_native_stack_offset_a   = 5
!address int_native_stack_offset_x   = 3
!address int_native_stack_offset_y   = 1
!address int_native_stack_offset_d   = 7
!address int_native_stack_offset_dbr = 8

!macro int_native_entry {
  +mx_16_bits
  phb
  phd
  pha
  phx
  phy
  +mx_8_bits
}

int_native_exit   +mx_16_bits
                  ply
                  plx
                  pla
                  pld
                  plb
                  +mx_8_bits

                  rti

int_native_irq    +int_native_entry
                  jmp (vec_native_irq)

int_native_nmi    +int_native_entry
                  jmp (vec_native_nmi)

int_native_brk    +int_native_entry
                  jmp (vec_native_brk)

int_native_cop    +int_native_entry
                  jmp (vec_native_cop)

int_native_abort  +int_native_entry
                  jmp (vec_native_abort)

; Emulation mode interrupts

!address int_emu_stack_offset_pc = 5
!address int_emu_stack_offset_p  = 4
!address int_emu_stack_offset_a  = 3
!address int_emu_stack_offset_x  = 2
!address int_emu_stack_offset_y  = 1

!macro int_emu_entry {
  pha
  phx
  phy
}

int_emu_exit      ply
                  plx
                  pla

                  rti

int_emu_irqbrk    +int_emu_entry
                  lda int_emu_stack_offset_p,s    // in emulation mode, we have to check the break flag on the
                  and # CPU_FLAG_BREAK            // CPU status register pushed to the stack by the interrupt
                  bne int_emu_brk                 // to determine if we're handling an hardware IRQ or software BRK
int_emu_irq       jmp (vec_emu_irq)
int_emu_brk       jmp (vec_emu_brk)

int_emu_nmi       +int_emu_entry
                  jmp (vec_emu_nmi)

int_emu_cop       +int_emu_entry
                  jmp (vec_emu_cop)

int_emu_abort     +int_emu_entry
                  jmp (vec_emu_abort)

int_rti           rti

; zero sum word is the last word before vectors
; this is updated during the build process to make the checksum of the ROM equal to 0
*=$ffde
  !word $0000

// native mode vector locations
*=$ffe0
!word int_rti          // 00FFE0,1 (Reserved)
!word int_rti          // 00FFE2,3 (Reserved)
!word int_native_cop   // 00FFE4,5 (COP)
!word int_native_brk   // 00FFE6,7 (BRK)
!word int_native_abort // 00FFE8,9 (ABORT)
!word int_native_nmi   // 00FFEA,B (NMI)
!word int_rti          // 00FFEC,D (Reserved)
!word int_native_irq   // 00FFEE,F (IRQ)

// emulation mode vector locations
*=$fff0
!word int_rti          // 00FFF0,1 (Reserved)
!word int_rti          // 00FFF2,3 (Reserved)
!word int_emu_cop      // 00FFF4,5 (COP)
!word int_rti          // 00FFF6,7 (Reserved)
!word int_emu_abort    // 00FFF8,9 (ABORT)
!word int_emu_nmi      // 00FFFA,B (NMI)
!word reset            // 00FFFC,D (Reset)
!word int_emu_irqbrk   // 00FFFE,F (IRQ/BRK)
