                  +mx_16_bits                     ; switch to 16 bits registers

; -----------------------------------------------------------------
;   The ROM checksum computes the sum of all the words in the ROM.
;   If that sum is not zero, either the ROM is corrupted or something
;   is wrong with the hardware.
;   In that case, we go to the error handler at .checksum_fail.
;   If the sum is zero, we fall through to the low RAM diagnostic.
; -----------------------------------------------------------------

.rom_checksum     ldx # ROM_END - ROM_START - 1   ; last location in ROM (16 bits aligned)
                  lda # 0                         ; begin sum

-                 clc                             ; add with carry...
                  adc ROM_START,x                 ; the word at the current location
                  dex                             ; decrement index
                  dex                             ; twice for 16 bits access
                  bpl -                           ; if X >=0 loop, else

                  cmp # 0                         ; did we find a sum of 0?
                  bne .checksum_fail              ; if not, something went wrong
                                                  ; if yes, fall through to the next test

; -----------------------------------------------------------------
;   The low RAM diagnostic writes a pseudo-random value to the RAM
;   located in Bank Zero, and verifies that it can read back the value
;   If it can't, it goes to the error handler at .memtest_fail
;
;   Note that the pseudo-random value written to a given address will be the same
;   accross mulitple invocation and accross computer resets. It is simply a monotonously
;   incrementing value.
; -----------------------------------------------------------------

.memtest                                          ; last location in low RAM (16 bits aligned)
                  ldx # LOW_RAM_END - LOW_RAM_START - 1

-                 txa                             ; use the current location address as the number we read and write
                  sta LOW_RAM_START,x             ; write it to the RAM...
                  cmp LOW_RAM_START,x             ; and read it back
                  bne .memtest_fail               ; if it's not equal then fail.

                  dex                             ; decrement index
                  dex                             ; twice for 16 bits access
                  bne -                           ; if X<>0 loop, else
                                                  ; if we reached the end without error, fall through to the next test

; -----------------------------------------------------------------
;   The high RAM diagnostic writes a pseudo-random value to the RAM
;   located outside of Bank Zero, and verifies that it can read back the value
;   If it can't, it goes to the error handler at .highmemtest_fail
;
;   Note that the pseudo-random value written to a given address will be the same
;   accross mulitple invocation and accross computer resets. It is simply a monotonously
;   incrementing value.
;
;   This routine assumes a functional stack. If the low RAM test has passed, this is normally the case
;   although the RAM tests are not fool proof.
; -----------------------------------------------------------------

!address .bank_start = $0000
!address .bank_end   = $ffff

.highmemtest      +x_8_bits                       ; use 8 bit indexes to change bank
                  ldy # HIGH_RAM_BANK_START       ; store bank number into Y

--                phy                             ; push it to the stack
                  plb                             ; pull it into Data Bank Register
                  +x_16_bits                      ; restore 16 bit indexes

                                                  ; last location in this bank (16 bits aligned)
                  ldx # .bank_end - .bank_start - 1

-                 txa                             ; use the current location address as the number we read and write
                  sta .bank_start,x               ; write it to the RAM (absolute indexed)...
                  cmp .bank_start,x               ; and read it back
                  bne .highmemtest_fail           ; if it's not equal then fail.

                  dex                             ; decrement index
                  dex                             ; twice for 16 bits access
                  bne -                           ; if X<>0 loop, else

                  +x_8_bits                       ; use 8 bit indexes to change bank

                  iny                             ; increment Y
                  cpy # HIGH_RAM_BANK_END + 1     ; did we overflow outside the high ram banks?
                  bne --                          ; if not keep looping

                  ldy # 0                         ; switch back to data bank zero
                  phy
                  plb

                  +x_16_bits                      ; restore 16 bit indexes
                  jmp .end_post                   ; jump to end of POST routine

; -----------------------------------------------------------------
;   The checksum failed handler will blink the emulation LED on a 200ms period.
;
;   Note: the period is clock dependent and only accurate if it has not been slowed down.
; -----------------------------------------------------------------

.checksum_fail    +mx_8_bits                      ; restore register sizes

                  sec                             ; set carry, we know emulation is off, so we have our 1 and our 0
-                 +delay_large_ms 200
                  xce
                  jmp -                           ; loop indefinitely

; -----------------------------------------------------------------
;   The memtest failed handler will blink the emulation LED with alternating
;   short (200ms) and long (400ms) blinks: . _ . _ . _
;
;   Note: the period is clock dependent and only accurate if it has not been slowed down.
; -----------------------------------------------------------------

.memtest_fail     +mx_8_bits                      ; restore register sizes

                  sec                             ; set carry, we know emulation is off, so we have our 1 and our 0
-                 +delay_large_ms 400
                  xce
                  +delay_large_ms 200
                  xce
                  +delay_large_ms 200
                  xce
                  +delay_large_ms 400
                  xce
                  jmp -                           ; loop indefinitely

; -----------------------------------------------------------------
;   The high memtest failed handler will blink the emulation LED with alternating
;   two short (200ms) and one long (400ms) blinks: . . _ . . _ . . _
;
;   Note: the period is clock dependent and only accurate if it has not been slowed down.
; -----------------------------------------------------------------

.highmemtest_fail +mx_8_bits                      ; restore register sizes

                  sec                             ; set carry, we know emulation is off, so we have our 1 and our 0
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
                  jmp -                           ; loop indefinitely

; -----------------------------------------------------------------
;   End of the POST routines
; -----------------------------------------------------------------

.end_post         +mx_8_bits                      ; restore register sizes before finishing
