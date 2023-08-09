!address prgm_old_irq_location = $14

; -----------------------------------------------------------------
;   main(): main user program start
; -----------------------------------------------------------------

main              +cpu_native

                  +m_16_bits                      ; Save existing IRQ handler, and add our own
                  lda vec_native_irq
                  sta prgm_old_irq_location
                  lda # int(prgm_irq)
                  sta vec_native_irq
                  +m_8_bits

                  cli                             ; enable interrupts

                  ldx # 0                         ; in a loop, print Hello world
-                 lda +, X                        ; ... to both the lcd and console
                  beq ++
                  phx
                  jsr acia_lcd_putc
                  plx
                  inx
                  jmp -
+                 !text "Hello, World!", 0
++
                  lda # "\r"                      ; add new line in console only
                  jsr acia_sync_putc
                  lda # "\n"
                  jsr acia_sync_putc

-                 jsr acia_sync_getc              ; get a character (blocking loop)
                  jsr acia_lcd_putc               ; print the character
                  jmp -                           ; loop indefinitely

; -----------------------------------------------------------------
;   acia_lcd_putc(): prints a character to both the LCD and the console
;
;   Parameters:
;       A = character to send, in ASCII
; -----------------------------------------------------------------

acia_lcd_putc     pha
                  jsr print_char
                  pla
                  jsr acia_sync_putc
                  rts

; -----------------------------------------------------------------
;   prgm_irq(): IRQ hook for user program
; -----------------------------------------------------------------

prgm_irq:         ; do nothing for now

                  jmp (prgm_old_irq_location)
