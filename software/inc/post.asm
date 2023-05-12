; -----------------------------------------------------------------
;   The ROM checksum computes the sum of all the words in the ROM.
;   If that sum is not zero, either the ROM is corrupted or something
;   is wrong with the hardware.
;   In that case, we go to the error handler at .checksum_fail.
;   If the sum is zero, we continue to the low RAM diagnostic.
; -----------------------------------------------------------------

.rom_checksum     +mx_16_bits                     ; switch to 16 bits registers

                  ldx # ROM_END - ROM_START - 1   ; last location in ROM (16 bits aligned)
                  lda # 0                         ; begin sum

-                 clc                             ; add with carry...
                  adc ROM_START,x                 ; the word at the current location
                  dex                             ; decrement index
                  dex                             ; twice for 16 bits access
                  bpl -                           ; if X >=0 loop, else

                  cmp # 0                         ; did we find a sum of 0?
                  +mx_8_bits                      ; restore register sizes, this does not change the result of cmp

                  bne .checksum_fail              ; if not, something went wrong
                  bra .memtest                    ; if yes, continue to the next test


; -----------------------------------------------------------------
;   The checksum failed handler will blink the emulation LED on a 200ms period.
;
;   Note: the period is clock dependent and only accurate if it has not been slowed down.
; -----------------------------------------------------------------

.checksum_fail    sec                             ; set carry, we know emulation is off, so we have our 1 and our 0
-                 +delay_large_ms 200
                  xce
                  bra -                           ; loop indefinitely

; -----------------------------------------------------------------
;   The low RAM diagnostic implements the March SS test
; -----------------------------------------------------------------

.memtest          !set .start = address(LOW_RAM_START)
                  !set .end = address(LOW_RAM_END)
                  !set .fail = address(.memtest_fail)
                  !source "inc/march.asm"

                  bra .highmemtest

; -----------------------------------------------------------------
;   The memtest failed handler will blink the emulation LED with alternating
;   short (200ms) and long (400ms) blinks: . _ . _ . _
;
;   Note: the period is clock dependent and only accurate if it has not been slowed down.
; -----------------------------------------------------------------

.memtest_fail     sec                             ; set carry, we know emulation is off, so we have our 1 and our 0
-                 +delay_large_ms 400
                  xce
                  +delay_large_ms 200
                  xce
                  +delay_large_ms 200
                  xce
                  +delay_large_ms 400
                  xce
                  bra -                           ; loop indefinitely

; -----------------------------------------------------------------
;   The high RAM diagnostic implements the March SS test, and manipulates the Data Bank Register
;   to test the whole banks.
;
;   This routine assumes a functional stack. If the low RAM test has passed, this is normally the case.
; -----------------------------------------------------------------

!address .bank_start = $0000
!address .bank_end   = $ffff

.highmemtest      ldy # HIGH_RAM_BANK_START       ; store bank number into Y

.highmemtest_1    phy                             ; push it to the stack
                  phy                             ; twice
                  plb                             ; pull it into Data Bank Register

                  !set .start = address(.bank_start)
                  !set .end = address(.bank_end)
                  !set .fail = address(.highmemtest_fail)
                  !source "inc/march.asm"

                  ply                             ; restore Y
                  iny                             ; increment Y
                  cpy # HIGH_RAM_BANK_END + 1     ; did we overflow outside the high ram banks?
                  +bne_long .highmemtest_1        ; if not keep looping
                                                  ; Note: not using "-" as a label because the include makes it unsafe
                  ldy # 0                         ; switch back to data bank zero
                  phy
                  plb

                  bra .end_post                   ; jump to end of POST routine

; -----------------------------------------------------------------
;   The high memtest failed handler will blink the emulation LED with alternating
;   two short (200ms) and one long (400ms) blinks: . . _ . . _ . . _
;
;   Note: the period is clock dependent and only accurate if it has not been slowed down.
; -----------------------------------------------------------------

.highmemtest_fail sec                             ; set carry, we know emulation is off, so we have our 1 and our 0
-                 +delay_large_ms 400
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
                  bra -                           ; loop indefinitely

; -----------------------------------------------------------------
;   End of the POST routines
; -----------------------------------------------------------------

.end_post
