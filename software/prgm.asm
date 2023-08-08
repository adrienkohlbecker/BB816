!address prgm_old_irq_location = $14

main:

  // Save existing IRQ handler, and add our own
  +m_16_bits
  lda vec_native_irq
  sta prgm_old_irq_location
  lda # int(prgm_irq)
  sta vec_native_irq
  +m_8_bits

  ; enable interrupts
  cli

  ; print Hello, World to both terminal and LCD
  ldx # 0
- lda +, X
  beq ++
  phx
  jsr acia_and_lcd_putchar
  plx
  inx
  jmp -
+ !text "Hello, World!", 0
++

  ; Add new lines for terminal only
  lda # "\r"
  jsr acia_putchar
  lda # "\n"
  jsr acia_putchar

- wai // wait for interrupts for ever
  jmp -

acia_and_lcd_putchar:
  pha
  jsr print_char
  pla
  jsr acia_putchar
  rts

prgm_irq:
  // do something
  jsr acia_getchar
  jsr acia_and_lcd_putchar

  jmp (prgm_old_irq_location)
