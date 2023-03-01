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

LCD_READ_BUSY_FLAG         = 1 << 7
LCD_READ_ADDR_COUNTER_MASK = $ff & !LCD_READ_BUSY_FLAG

; lcd_init
; resets the LCD to its default state
lcd_init:
  lda # LCD_CMD_CLEAR_DISPLAY
  jsr lcd_instruction

  lda # LCD_CMD_FUNCTION_SET_5x8_DOTS | LCD_CMD_FUNCTION_SET_TWO_LINES | LCD_CMD_FUNCTION_SET_8BIT_MODE
  jsr lcd_instruction

  lda # LCD_CMD_DISPLAY_CONTROL_BLINKING_ON | LCD_CMD_DISPLAY_CONTROL_CURSOR_ON | LCD_CMD_DISPLAY_CONTROL_DISPLAY_ON
  jsr lcd_instruction

  lda # LCD_CMD_ENTRY_MODE_SET_DISPLAY_STATIC | LCD_CMD_ENTRY_MODE_SET_LTR
  jsr lcd_instruction

  rts

; lcd_instruction:
; send a command to the LCD
;
; arguments: A = command to send
lcd_instruction:
    pha ; save command
    jsr lcd_wait
    plx ; restore command into X

    ; Get current control signals
    lda IO_0_VIA_PORTB

    ; Clear RS/RW/E bits
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
    sta IO_0_VIA_PORTB

    ; Output command to external bus
    stx IO_0_VIA_PORTA

    ; PORT A is output
    ldx # $ff
    stx IO_0_VIA_DDRA

    ; Set the Enable bit to send the instruction
    ora # VIA_PORT_B0_LCD_E
    sta IO_0_VIA_PORTB

    ; Clear RS/RW/E bits
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
    sta IO_0_VIA_PORTB

    ; Clears external bus
    lda # VIA_PORTA_DEFAULT
    sta IO_0_VIA_PORTA
    lda # VIA_DDRA_DEFAULT
    sta IO_0_VIA_DDRA

    rts

; print_char:
; prints a single character to the LCD
;
; Arguments: A=character
print_char:
    pha ; save char
    jsr lcd_wait
    plx ; restore char into X

    ; Get current control signals
    lda IO_0_VIA_PORTB

    ; Clear RW/E bits, set RS
    and # $ff & !(VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
    ora # VIA_PORT_B2_LCD_RS
    sta IO_0_VIA_PORTB

    ; Output char to external bus
    stx IO_0_VIA_PORTA

    ; PORT A is output
    ldx # $ff
    stx IO_0_VIA_DDRA

    ; Set the Enable bit + RS to send the instruction
    ora # VIA_PORT_B0_LCD_E | VIA_PORT_B2_LCD_RS
    sta IO_0_VIA_PORTB

    ; Clear RS/RW/E bits
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
    sta IO_0_VIA_PORTB

    ; Clears external bus
    lda # VIA_PORTA_DEFAULT
    sta IO_0_VIA_PORTA
    lda # VIA_DDRA_DEFAULT
    sta IO_0_VIA_DDRA

    rts

; lcd_read_address: Reads address counter
; No arguments
; Returns value in A
lcd_read_address:
    ; Get current control signals
    lda IO_0_VIA_PORTB

    ; PORT A is input
    stz IO_0_VIA_DDRA

    ; Clear RS/E bits; Set RW
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B0_LCD_E)
    ora # VIA_PORT_B1_LCD_RW
    sta IO_0_VIA_PORTB

    ; Set the Enable bit + RW to read the data
    ora # VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E
    sta IO_0_VIA_PORTB

    ; Get value of busy flag
    ldx IO_0_VIA_PORTA

    ; Clear RS/RW/E bits
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
    sta IO_0_VIA_PORTB

    ; strip busy bit
    txa
    and # LCD_READ_ADDR_COUNTER_MASK

    ; Restore DDRA
    ldx # VIA_DDRA_DEFAULT
    stx IO_0_VIA_DDRA

    rts

; lcd_wait: Wait for the LCD busy flag to clear
; No arguments
lcd_wait:
    ; Get current control signals
    ldx IO_0_VIA_PORTB

.lcd_wait_loop:
    txa

    ; PORT A is input
    stz IO_0_VIA_DDRA

    ; Clear RS/E bits; Set RW
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B0_LCD_E)
    ora # VIA_PORT_B1_LCD_RW
    sta IO_0_VIA_PORTB

    ; Set the Enable bit + RW to read the data
    ora # VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E
    sta IO_0_VIA_PORTB

    ; Get value of busy flag
    tax
    lda IO_0_VIA_PORTA
    bit # LCD_READ_BUSY_FLAG
    bne .lcd_wait_loop
    txa

    ; Clear RS/RW/E bits
    and # $ff & !(VIA_PORT_B2_LCD_RS | VIA_PORT_B1_LCD_RW | VIA_PORT_B0_LCD_E)
    sta IO_0_VIA_PORTB

    ; Restore DDRA
    lda # VIA_DDRA_DEFAULT
    sta IO_0_VIA_DDRA

    rts
