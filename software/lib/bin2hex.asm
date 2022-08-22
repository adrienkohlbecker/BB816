; bin2hex: convert 8 bit number to hexadecimal
; argument: A=byte to convert
; return: A=higher nibble in hex, B=lower nibble in hex
bin2hex:
    tay
    and # %00001111 ; lower nibble
    tax
    lda .hexlookup,x
    xba ; save lower HEX in B
    tya ; restore byte
    lsr ; higher nibble
    lsr
    lsr
    lsr
    tax
    lda .hexlookup,x
    rts

; bin2hex16: convert 16 bit number to hexadecimal
; argument: B,A=word to convert
; return: A=fourth nibble in hex, B=third nibble in hex, X=second nibble in hex, Y=first nibble in hex
bin2hex16:
  xba ; save B
  pha
  xba

  jsr bin2hex

  tax ; save second nibble to X
  xba
  tay ; save first nibble to Y

  pla ; restore B into A
  phy ; save registers
  phx

  jsr bin2hex

  plx
  ply

  rts

.hexlookup:
    !text "0123456789ABCDEF"

; print_hex: prints 8 bit hex number in ascii to LCD
; argument: A=byte to print
print_hex:
  jsr bin2hex
  xba
  pha
  xba
  jsr print_char
  pla
  jsr print_char
  rts

; print_hex16: prints 16 bit hex number in ascii to LCD
; argument: B,A=word to print
print_hex16:
  pha
  xba
  jsr print_hex
  pla
  jsr print_hex
  rts
