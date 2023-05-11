!address prgm_old_irq_location = $14

; -----------------------------------------------------------------
;   main(): main user program start
; -----------------------------------------------------------------

main              +m_16_bits                      ; Save existing IRQ handler, and add our own
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
                  jsr acia_and_lcd_putchar
                  plx
                  inx
                  jmp -
+                 !text "Hello, World!", 0
++
                  lda # "\r"                      ; add new line in console only
                  jsr acia_putchar
                  lda # "\n"
                  jsr acia_putchar

-                 wai                             ; wait for interrupts for ever
                  jmp -

; -----------------------------------------------------------------
;   acia_and_lcd_putchar(): prints a character to both the LCD and the console
;
;   Parameters:
;       A = character to send, in ASCII
; -----------------------------------------------------------------

acia_and_lcd_putchar
                  pha
                  jsr print_char
                  pla
                  jsr acia_putchar
                  rts

; -----------------------------------------------------------------
;   prgm_irq(): IRQ hook for user program
; -----------------------------------------------------------------

prgm_irq:         jsr acia_getchar
                  jsr acia_and_lcd_putchar

                  jmp (prgm_old_irq_location)
