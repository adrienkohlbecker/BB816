!cpu 65816
!initmem $ea

; -----------------------------------------------------------------
;   Memory map
; -----------------------------------------------------------------

; 0000 0000 0000 0000 0000 0000 - 0000 0000 1111 1111 1111 1111 | 000000 00FFFF | Bank 0 (see below)
; 1111 0000 0000 0000 0000 0000 - 1111 0111 1111 1111 1111 1111 | F00000 F7FFFF | Extended RAM
;
; Bank0:
;
; 0000 0000 0000 0000 - 0000 0000 1111 1111 | 0000 - 00FF | Direct page
; 0000 0001 0000 0000 - 0000 0001 1111 1111 | 0100 - 01FF | Stack
; 0000 0010 0000 0000 - 0111 1110 1111 1111 | 0200 - 7EFF | General Purpose RAM
; 0111 1111 0000 0000 - 0111 1111 0111 1111 | 7F00 - 7F7F | [Reserved for more I/O in future hardware revisions]
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

!address {
  ROM_START     = $8000
  ROM_END       = $ffff
  LOW_RAM_START = $0000
  LOW_RAM_END   = $7eff

  IO_0 = $7F80
  IO_1 = $7F90
  IO_2 = $7FA0
  IO_3 = $7FB0
  IO_4 = $7FC0
  IO_5 = $7FD0
  IO_6 = $7FE0
  IO_7 = $7FF0
}

HIGH_RAM_BANK_START = $f0
HIGH_RAM_BANK_END   = $f7

; -----------------------------------------------------------------
;   Configuration defines
; -----------------------------------------------------------------

; Speed of the main CPU clock
CPU_SPEED_MHZ = 4.0

; Enable Power-On Self Test routines
; FLAG_ENABLE_POST

; Enable ACIA transmit bug workaround
FLAG_ACIA_XMIT_BUG

; -----------------------------------------------------------------
;   Constants
; -----------------------------------------------------------------

CPU_FLAG_CARRY        = 1 << 0
CPU_FLAG_ZERO         = 1 << 1
CPU_FLAG_IRQ_DISABLE  = 1 << 2
CPU_FLAG_DECIMAL      = 1 << 3
CPU_FLAG_BREAK        = 1 << 4 ; Emulation mode
CPU_FLAG_INDEX_8BIT   = 1 << 4 ; Native mode
CPU_FLAG_MEMORY_8BIT  = 1 << 5 ; Native mode
CPU_FLAG_OVERFLOW     = 1 << 6
CPU_FLAG_NEGATIVE     = 1 << 7

; -----------------------------------------------------------------
;   IRQ jump vectors
; -----------------------------------------------------------------

!address vec_native_irq   = $00 ; 2 bytes
!address vec_native_nmi   = $02 ; 2 bytes
!address vec_native_abort = $04 ; 2 bytes
!address vec_native_brk   = $06 ; 2 bytes
!address vec_native_cop   = $08 ; 2 bytes
!address vec_emu_irq      = $0A ; 2 bytes
!address vec_emu_nmi      = $0C ; 2 bytes
!address vec_emu_abort    = $0E ; 2 bytes
!address vec_emu_brk      = $10 ; 2 bytes
!address vec_emu_cop      = $12 ; 2 bytes

; -----------------------------------------------------------------
;   Program start
; -----------------------------------------------------------------

*=ROM_START

!source "lib/macros.asm"

reset             ldx #$ff                        ; initialize stack pointer to 01FF
                  txs

                  +cpu_native

post              !ifdef FLAG_ENABLE_POST {       ; execute POST routine only if needed
                    !source "inc/post.asm"
                  }

kernel_init       jsr via_init                    ; initialize device drivers
                  jsr lcd_init
                  jsr acia_init

                  +m_16_bits                      ; initialize interrupt vectors
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

                  stp                             ; shouldn't be reached

; -----------------------------------------------------------------
;   int_native_entry / int_native_exit
;
;   Description:
;     When dealing with an IRQ in native mode, the CPU finishes the currently executing instruction,
;     then it pushes the program counter to the stack, then the status register, before calling this handler.
;     In order to preserve the full execution environment of the interrupted code, even though it is not
;     optimized for speed, we save the data bank register, the direct page register, as well as A, X and Y.
;     Since we don't know whether the interrupted code was using 8 or 16 bits registers or indexes,
;     it is best to assume 16 bits and save their whole contents.
;     The IRQ handler is called with 8 bits registers and indexes, and switching does not impact the
;     return from interrupt because the status register was saved by the CPU before we get here.
; -----------------------------------------------------------------

!address int_native_stack_offset_pbr = 12
!address int_native_stack_offset_pc  = 10
!address int_native_stack_offset_p   = 9
!address int_native_stack_offset_a   = 5
!address int_native_stack_offset_x   = 3
!address int_native_stack_offset_y   = 1
!address int_native_stack_offset_d   = 7
!address int_native_stack_offset_dbr = 8

!macro int_native_entry {
                  +mx_16_bits                     ; select 16 bit registers, this will work even if the
                  phb                             ; interrupted code was using 8 bit registers
                  phd
                  pha
                  phx
                  phy
                  +mx_8_bits                      ; and go back to 8 for interrupt entrypoint
}

int_native_exit   +mx_16_bits                     ; restore 16 bits registers
                  ply
                  plx
                  pla
                  pld
                  plb
                  +mx_8_bits                      ; ensures code assembled after this uses 8 bits registers

.int_rti          rti                             ; resume interrupted code

; -----------------------------------------------------------------
;   int_emu_entry / int_emu_exit
; -----------------------------------------------------------------

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

; -----------------------------------------------------------------
;   Interrupt handlers
; -----------------------------------------------------------------

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

int_emu_irqbrk    +int_emu_entry
                  lda int_emu_stack_offset_p,s    ; in emulation mode, we have to check the break flag on the
                  and # CPU_FLAG_BREAK            ; CPU status register pushed to the stack by the interrupt
                  bne int_emu_brk                 ; to determine if we're handling an hardware IRQ or software BRK

int_emu_irq       jmp (vec_emu_irq)

int_emu_brk       jmp (vec_emu_brk)

int_emu_nmi       +int_emu_entry
                  jmp (vec_emu_nmi)

int_emu_cop       +int_emu_entry
                  jmp (vec_emu_cop)

int_emu_abort     +int_emu_entry
                  jmp (vec_emu_abort)

; -----------------------------------------------------------------
;   Libraries
; -----------------------------------------------------------------

!source "lib/bin2hex.asm"
!source "lib/via.asm"
!source "lib/lcd.asm"
!source "lib/acia.asm"

; -----------------------------------------------------------------
;   Checksum
; -----------------------------------------------------------------

; zero sum word is the last word before vectors
; this is updated during the build process to make the checksum of the ROM equal to 0
*=$ffde
  !word $0000

; native mode vector locations
*=$ffe0
!word .int_rti         ; 00FFE0,1 (Reserved)
!word .int_rti         ; 00FFE2,3 (Reserved)
!word int_native_cop   ; 00FFE4,5 (COP)
!word int_native_brk   ; 00FFE6,7 (BRK)
!word int_native_abort ; 00FFE8,9 (ABORT)
!word int_native_nmi   ; 00FFEA,B (NMI)
!word .int_rti         ; 00FFEC,D (Reserved)
!word int_native_irq   ; 00FFEE,F (IRQ)

; emulation mode vector locations
*=$fff0
!word .int_rti         ; 00FFF0,1 (Reserved)
!word .int_rti         ; 00FFF2,3 (Reserved)
!word int_emu_cop      ; 00FFF4,5 (COP)
!word .int_rti         ; 00FFF6,7 (Reserved)
!word int_emu_abort    ; 00FFF8,9 (ABORT)
!word int_emu_nmi      ; 00FFFA,B (NMI)
!word reset            ; 00FFFC,D (Reset)
!word int_emu_irqbrk   ; 00FFFE,F (IRQ/BRK)
