; -----------------------------------------------------------------
;   Command bits
; -----------------------------------------------------------------

LCD_CMD_CLEAR_DISPLAY                 = 1 << 0
LCD_CMD_RETURN_HOME                   = 1 << 1
LCD_CMD_ENTRY_MODE_SET_DISPLAY_STATIC = 1 << 2 | 0 << 0
LCD_CMD_ENTRY_MODE_SET_DISPLAY_SHIFT  = 1 << 2 | 1 << 0
LCD_CMD_ENTRY_MODE_SET_RTL            = 1 << 2 | 0 << 1
LCD_CMD_ENTRY_MODE_SET_LTR            = 1 << 2 | 1 << 1
LCD_CMD_DISPLAY_CONTROL_BLINKING_OFF  = 1 << 3 | 0 << 0
LCD_CMD_DISPLAY_CONTROL_BLINKING_ON   = 1 << 3 | 1 << 0
LCD_CMD_DISPLAY_CONTROL_CURSOR_OFF    = 1 << 3 | 0 << 1
LCD_CMD_DISPLAY_CONTROL_CURSOR_ON     = 1 << 3 | 1 << 1
LCD_CMD_DISPLAY_CONTROL_DISPLAY_OFF   = 1 << 3 | 0 << 2
LCD_CMD_DISPLAY_CONTROL_DISPLAY_ON    = 1 << 3 | 1 << 2
LCD_CMD_SHIFT_CURSOR_LEFT             = 1 << 4 | 0 << 2
LCD_CMD_SHIFT_CURSOR_RIGHT            = 1 << 4 | 1 << 2
LCD_CMD_SHIFT_DISPLAY_LEFT            = 1 << 4 | 2 << 2
LCD_CMD_SHIFT_DISPLAY_RIGHT           = 1 << 4 | 3 << 2
LCD_CMD_FUNCTION_SET_5x8_DOTS         = 1 << 5 | 0 << 2
LCD_CMD_FUNCTION_SET_5x10_DOTS        = 1 << 5 | 1 << 2
LCD_CMD_FUNCTION_SET_ONE_LINE         = 1 << 5 | 0 << 3
LCD_CMD_FUNCTION_SET_TWO_LINES        = 1 << 5 | 1 << 3
LCD_CMD_FUNCTION_SET_4BIT_MODE        = 1 << 5 | 0 << 4
LCD_CMD_FUNCTION_SET_8BIT_MODE        = 1 << 5 | 1 << 4
LCD_CMD_SET_CGRAM_ADDR                = 1 << 6
LCD_CMD_SET_DDRAM_ADDR                = 1 << 7

; -----------------------------------------------------------------
;   Masks
; -----------------------------------------------------------------

LCD_READ_BUSY_FLAG         = 1 << 7
LCD_READ_ADDR_COUNTER_MASK = $ff & !LCD_READ_BUSY_FLAG

; -----------------------------------------------------------------
;   lcd_init(): resets the LCD to its default state
; -----------------------------------------------------------------

lcd_init          lda # LCD_CMD_CLEAR_DISPLAY
                  jsr lcd_instruction

                  lda # LCD_CMD_FUNCTION_SET_5x8_DOTS | LCD_CMD_FUNCTION_SET_TWO_LINES | LCD_CMD_FUNCTION_SET_8BIT_MODE
                  jsr lcd_instruction

                  lda # LCD_CMD_DISPLAY_CONTROL_BLINKING_ON | LCD_CMD_DISPLAY_CONTROL_CURSOR_ON | LCD_CMD_DISPLAY_CONTROL_DISPLAY_ON
                  jsr lcd_instruction

                  lda # LCD_CMD_ENTRY_MODE_SET_DISPLAY_STATIC | LCD_CMD_ENTRY_MODE_SET_LTR
                  jsr lcd_instruction

                  rts

; -----------------------------------------------------------------
;   lcd_instruction(): send a command to the LCD
;
;   Parameters:
;       A = command to send
; -----------------------------------------------------------------

lcd_instruction   pha                             ; save command
                  jsr lcd_wait
                  plx                             ; restore command into X

                  lda IO_0_VIA_PORTB              ; Get current control signals

                                                  ; Clear RS/RW/E bits
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
                  sta IO_0_VIA_PORTB

                  stx IO_0_VIA_PORTA              ; Output command to external bus

                  ldx # $ff                       ; PORT A is output
                  stx IO_0_VIA_DDRA

                  ora # VIA_PORT_B0_LCD_E         ; Set the Enable bit to send the instruction
                  sta IO_0_VIA_PORTB

                                                  ; Clear RS/RW/E bits
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
                  sta IO_0_VIA_PORTB

                  lda # VIA_PORTA_DEFAULT         ; Clears external bus
                  sta IO_0_VIA_PORTA
                  lda # VIA_DDRA_DEFAULT
                  sta IO_0_VIA_DDRA

                  rts

; -----------------------------------------------------------------
;   print_char(): prints a single character to the LCD
;   Parameters:
;       A = char to print
; -----------------------------------------------------------------

print_char        pha                             ; save char
                  jsr lcd_wait
                  plx                             ; restore char into X

                  lda IO_0_VIA_PORTB              ; Get current control signals

                                                  ; Clear RW/E bits, set RS
                  and # $ff & !(VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
                  ora # VIA_PORT_B2_LCD_RS
                  sta IO_0_VIA_PORTB

                  stx IO_0_VIA_PORTA              ; Output char to external bus

                  ldx # $ff                       ; PORT A is output
                  stx IO_0_VIA_DDRA

                                                  ; Set the Enable bit + RS to send the instruction
                  ora # VIA_PORT_B0_LCD_E | VIA_PORT_B2_LCD_RS
                  sta IO_0_VIA_PORTB

                                                  ; Clear RS/RW/E bits
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
                  sta IO_0_VIA_PORTB

                  lda # VIA_PORTA_DEFAULT         ; Clears external bus
                  sta IO_0_VIA_PORTA
                  lda # VIA_DDRA_DEFAULT
                  sta IO_0_VIA_DDRA

                  rts

; -----------------------------------------------------------------
;   lcd_read_address(): Reads address counter
;
;   Returns:
;       A: address counter
; -----------------------------------------------------------------

lcd_read_address  lda IO_0_VIA_PORTB              ; Get current control signals

                  stz IO_0_VIA_DDRA               ; PORT A is input

                                                  ; Clear RS/E bits; Set RW
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B0_LCD_E)
                  ora # VIA_PORT_B1_LCD_RW
                  sta IO_0_VIA_PORTB

                                                  ; Set the Enable bit + RW to read the data
                  ora # VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E
                  sta IO_0_VIA_PORTB

                  ldx IO_0_VIA_PORTA              ; Get value of busy flag

                                                  ; Clear RS/RW/E bits
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
                  sta IO_0_VIA_PORTB

                  txa                             ; strip busy bit
                  and # LCD_READ_ADDR_COUNTER_MASK

                  ldx # VIA_DDRA_DEFAULT           ; Restore DDRA
                  stx IO_0_VIA_DDRA

                  rts

; -----------------------------------------------------------------
;   lcd_wait(): Wait for the LCD busy flag to clear
; -----------------------------------------------------------------

lcd_wait          ldx IO_0_VIA_PORTB              ; Get current control signals

.lcd_wait_loop    txa

                  stz IO_0_VIA_DDRA               ; PORT A is input

                                                  ; Clear RS/E bits; Set RW
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B0_LCD_E)
                  ora # VIA_PORT_B1_LCD_RW
                  sta IO_0_VIA_PORTB

                                                  ; Set the Enable bit + RW to read the data
                  ora # VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E
                  sta IO_0_VIA_PORTB

                  tax                             ; Get value of busy flag
                  lda IO_0_VIA_PORTA
                  bit # LCD_READ_BUSY_FLAG
                  bne .lcd_wait_loop
                  txa

                                                  ; Clear RS/RW/E bits
                  and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
                  sta IO_0_VIA_PORTB

                  lda # VIA_DDRA_DEFAULT          ; Restore DDRA
                  sta IO_0_VIA_DDRA

                  rts
