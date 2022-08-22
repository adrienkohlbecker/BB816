!address IO_1_ACIA_DATA_REGISTER    = IO_1 + $0
!address IO_1_ACIA_STATUS_REGISTER  = IO_1 + $1
!address IO_1_ACIA_COMMAND_REGISTER = IO_1 + $2
!address IO_1_ACIA_CONTROL_REGISTER = IO_1 + $3

ACIA_STATUS_PARITY_ERROR_DETECTED           = 0b1 << 0
ACIA_STATUS_FRAMING_ERROR_DETECTED          = 0b1 << 1
ACIA_STATUS_OVERRUN_HAS_OCCURRED            = 0b1 << 2
ACIA_STATUS_RECEIVER_DATA_REGISTER_FULL     = 0b1 << 3
ACIA_STATUS_TRANSMITTER_DATA_REGISTER_EMPTY = 0b1 << 4
ACIA_STATUS_DATA_CARRIER_DETECT_HIGH        = 0b1 << 5
ACIA_STATUS_DATA_SET_READY_HIGH             = 0b1 << 6
ACIA_STATUS_INTERRUPT_OCCURRED              = 0b1 << 7

ACIA_CONTROL_BAUD_RATE_115200 = 0b0000 << 0
ACIA_CONTROL_BAUD_RATE_50     = 0b0001 << 0
ACIA_CONTROL_BAUD_RATE_75     = 0b0010 << 0
ACIA_CONTROL_BAUD_RATE_109_92 = 0b0011 << 0
ACIA_CONTROL_BAUD_RATE_134_58 = 0b0100 << 0
ACIA_CONTROL_BAUD_RATE_150    = 0b0101 << 0
ACIA_CONTROL_BAUD_RATE_300    = 0b0110 << 0
ACIA_CONTROL_BAUD_RATE_600    = 0b0111 << 0
ACIA_CONTROL_BAUD_RATE_1200   = 0b1000 << 0
ACIA_CONTROL_BAUD_RATE_1800   = 0b1001 << 0
ACIA_CONTROL_BAUD_RATE_2400   = 0b1010 << 0
ACIA_CONTROL_BAUD_RATE_3600   = 0b1011 << 0
ACIA_CONTROL_BAUD_RATE_4800   = 0b1100 << 0
ACIA_CONTROL_BAUD_RATE_7200   = 0b1101 << 0
ACIA_CONTROL_BAUD_RATE_9600   = 0b1110 << 0
ACIA_CONTROL_BAUD_RATE_19200  = 0b1111 << 0
ACIA_CONTROL_RECEIVER_CLOCK_EXTERNAL  = 0b0 << 4
ACIA_CONTROL_RECEIVER_CLOCK_BAUD_RATE = 0b1 << 4
ACIA_CONTROL_WORD_LENGTH_8 = 0b00 << 5
ACIA_CONTROL_WORD_LENGTH_7 = 0b01 << 5
ACIA_CONTROL_WORD_LENGTH_6 = 0b10 << 5
ACIA_CONTROL_WORD_LENGTH_5 = 0b11 << 5
ACIA_CONTROL_STOPBIT_1 = 0b0 << 7
ACIA_CONTROL_STOPBIT_2 = 0b1 << 7 ; 1.5 when word length is 5

ACIA_COMMAND_DATA_TERMINAL_READY_DEASSERT = 0b0 << 0
ACIA_COMMAND_DATA_TERMINAL_READY_ASSERT   = 0b1 << 0
ACIA_COMMAND_RECEIVER_IRQ_ENABLED  = 0b0 << 1
ACIA_COMMAND_RECEIVER_IRQ_DISABLED = 0b1 << 1
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_DEASSERT_TRANSMITTER_DISABLED            = 0b00 << 2
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_ENABLED                 = 0b01 << 2 ; Do not use
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED                = 0b10 << 2
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED_TRANSMIT_BREAK = 0b11 << 2
ACIA_COMMAND_RECEIVER_ECHO_DISABLED = 0b0 << 4
ACIA_COMMAND_RECEIVER_ECHO_ENABLED  = 0b1 << 4 ; Bit 2 and 3 must be zero.
ACIA_COMMAND_RECEIVER_PARITY_DISABLED = 0b0 << 5
ACIA_COMMAND_RECEIVER_PARITY_ENABLED  = 0b1 << 5 ; Parity should never be enabled
ACIA_CONTROL_PARITY_ODD                  = 0b00 << 6 ; Parity should never be enabled
ACIA_CONTROL_PARITY_EVEN                 = 0b01 << 6 ; Parity should never be enabled
ACIA_CONTROL_PARITY_MARK_CHECK_DISABLED  = 0b10 << 6 ; Parity should never be enabled
ACIA_CONTROL_PARITY_SPACE_CHECK_DISABLED = 0b11 << 6 ; Parity should never be enabled

acia_init:
  ; programmatically reset the chip by writing the status register
  stz IO_1_ACIA_STATUS_REGISTER

  ; set up the ACIA with
  ; - baud rate 300 (smallest supported by MCP2221A)
  ; - no external receiver clock, RxC pin outputs the baud rate
  ; - 8 bit word length
  ; - 1 stop bit
  lda # ACIA_CONTROL_BAUD_RATE_300 | ACIA_CONTROL_RECEIVER_CLOCK_BAUD_RATE | ACIA_CONTROL_WORD_LENGTH_8 | ACIA_CONTROL_STOPBIT_1
  sta IO_1_ACIA_CONTROL_REGISTER

  ; further set up the ACIA with
  ; - /DTR = Low
  ; - Receiver IRQ off
  ; - /RTS = Low, Transmitter enabled, transmitter IRQ off
  ; - Echo mode disabled
  ; - Parity disabled
  lda # ACIA_COMMAND_DATA_TERMINAL_READY_ASSERT | ACIA_COMMAND_RECEIVER_IRQ_DISABLED | ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED | ACIA_COMMAND_RECEIVER_ECHO_DISABLED | ACIA_COMMAND_RECEIVER_PARITY_DISABLED
  sta IO_1_ACIA_COMMAND_REGISTER

  rts

; acia_putchar: Sends a byte over serial. Blocking loop until transmit is available.
;
; arguments: A = byte to send
acia_putchar:
  ; move byte to X register
  tax

  ; wait until we can transmit
  ; Note: With W65C51N, this will not work due to hardware bug!
  ; The transmitter data register empty bit is always set
  ;   lda # ACIA_STATUS_TRANSMITTER_DATA_REGISTER_EMPTY
  ; - bit IO_1_ACIA_STATUS_REGISTER
  ;   beq -

  ; transmit byte
  stx IO_1_ACIA_DATA_REGISTER

  ; wait for the byte to be transmitted
  ; With a 8N1 configuration, 10 bits need to go out per byte
  ; At 300 baud, that's 1/30s per byte
  +delay_medium_ms 1000.0/30

  rts

; acia_getchar: Receives a byte over serial. Blocking loop until something is received.
;
; No arguments
; Returns byte in A
acia_getchar:
  ; wait until a byte is available
  lda # ACIA_STATUS_RECEIVER_DATA_REGISTER_FULL
- bit IO_1_ACIA_STATUS_REGISTER
  beq -

  ; get received byte and return
  lda IO_1_ACIA_DATA_REGISTER
  rts
