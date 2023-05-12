.hexlookup        !text "0123456789ABCDEF"

; -----------------------------------------------------------------
;   bin2hex(): convert 8 bit number to hexadecimal
;
;   Parameters:
;       A = byte to convert
;   Returns:
;       A: higher nibble in ASCII hex representation
;       B: lower nibble in ASCII hex representation
; -----------------------------------------------------------------

bin2hex           tay
                  and # %00001111                 ; get lower nibble
                  tax
                  lda .hexlookup,x
                  xba                             ; save lower HEX in B
                  tya                             ; restore byte
                  lsr                             ; higher nibble, shift four times
                  lsr
                  lsr
                  lsr
                  tax
                  lda .hexlookup,x
                  rts

; -----------------------------------------------------------------
;   bin2hex16(): convert 8 bit number to hexadecimal
;
;   Parameters:
;       A = low byte of word to convert
;       B = high byte word to convert
;   Returns:
;       A: fourth nibble in ASCII hex representation
;       B: third nibble in ASCII hex representation
;       X: second nibble in ASCII hex representation
;       Y: first nibble in ASCII hex representation
; -----------------------------------------------------------------

bin2hex16         xba                             ; save B
                  pha
                  xba

                  jsr bin2hex

                  tax                             ; save second nibble to X
                  xba
                  tay                             ; save first nibble to Y

                  pla                             ; restore B into A
                  phy                             ; save registers
                  phx

                  jsr bin2hex

                  plx
                  ply

                  rts

; -----------------------------------------------------------------
;   print_hex():  prints 8 bit hex number in ascii to LCD
;
;   Parameters:
;       A = byte to print
; -----------------------------------------------------------------

print_hex         jsr bin2hex
                  xba
                  pha
                  xba
                  jsr print_char
                  pla
                  jsr print_char
                  rts

; -----------------------------------------------------------------
;   print_hex16():  prints 16 bit hex number in ascii to LCD
;
;   Parameters:
;       A = low byte of word to convert
;       B = high byte word to convert
; -----------------------------------------------------------------

print_hex16       pha
                  xba
                  jsr print_hex
                  pla
                  jsr print_hex
                  rts

; -----------------------------------------------------------------
;   print_hex():  prints 8 bit hex number in ascii to ACIA
;
;   Parameters:
;       A = byte to print
; -----------------------------------------------------------------

acia_print_hex    jsr binhex
                  xba
                  pha
                  xba
                  jsr acia_sync_putc
                  pla
                  jsr acia_sync_putc
                  rts
