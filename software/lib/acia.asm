!address IO_1_ACIA_DATA_REGISTER    = IO_1 + $0
!address IO_1_ACIA_STATUS_REGISTER  = IO_1 + $1
!address IO_1_ACIA_COMMAND_REGISTER = IO_1 + $2
!address IO_1_ACIA_CONTROL_REGISTER = IO_1 + $3

ACIA_STATUS_PARITY_ERROR_DETECTED           = 1 << 0
ACIA_STATUS_FRAMING_ERROR_DETECTED          = 1 << 1
ACIA_STATUS_OVERRUN_HAS_OCCURRED            = 1 << 2
ACIA_STATUS_RECEIVER_DATA_REGISTER_FULL     = 1 << 3
ACIA_STATUS_TRANSMITTER_DATA_REGISTER_EMPTY = 1 << 4
ACIA_STATUS_DATA_CARRIER_DETECT_HIGH        = 1 << 5
ACIA_STATUS_DATA_SET_READY_HIGH             = 1 << 6
ACIA_STATUS_INTERRUPT_OCCURRED              = 1 << 7

ACIA_CONTROL_BAUD_RATE_115200 = 0  << 0
ACIA_CONTROL_BAUD_RATE_50     = 1  << 0
ACIA_CONTROL_BAUD_RATE_75     = 2  << 0
ACIA_CONTROL_BAUD_RATE_109_92 = 3  << 0
ACIA_CONTROL_BAUD_RATE_134_58 = 4  << 0
ACIA_CONTROL_BAUD_RATE_150    = 5  << 0
ACIA_CONTROL_BAUD_RATE_300    = 6  << 0
ACIA_CONTROL_BAUD_RATE_600    = 7  << 0
ACIA_CONTROL_BAUD_RATE_1200   = 8  << 0
ACIA_CONTROL_BAUD_RATE_1800   = 9  << 0
ACIA_CONTROL_BAUD_RATE_2400   = 10 << 0
ACIA_CONTROL_BAUD_RATE_3600   = 11 << 0
ACIA_CONTROL_BAUD_RATE_4800   = 12 << 0
ACIA_CONTROL_BAUD_RATE_7200   = 13 << 0
ACIA_CONTROL_BAUD_RATE_9600   = 14 << 0
ACIA_CONTROL_BAUD_RATE_19200  = 15 << 0
ACIA_CONTROL_RECEIVER_CLOCK_EXTERNAL  = 0 << 4
ACIA_CONTROL_RECEIVER_CLOCK_BAUD_RATE = 1 << 4
ACIA_CONTROL_WORD_LENGTH_8 = 0 << 5
ACIA_CONTROL_WORD_LENGTH_7 = 1 << 5
ACIA_CONTROL_WORD_LENGTH_6 = 2 << 5
ACIA_CONTROL_WORD_LENGTH_5 = 3 << 5
ACIA_CONTROL_STOPBIT_1 = 0 << 7
ACIA_CONTROL_STOPBIT_2 = 1 << 7 ; 1.5 when word length is 5

ACIA_COMMAND_DATA_TERMINAL_READY_DEASSERT = 0 << 0
ACIA_COMMAND_DATA_TERMINAL_READY_ASSERT   = 1 << 0
ACIA_COMMAND_RECEIVER_IRQ_ENABLED  = 0 << 1
ACIA_COMMAND_RECEIVER_IRQ_DISABLED = 1 << 1
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_DEASSERT_TRANSMITTER_DISABLED            = 0 << 2
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_ENABLED                 = 1 << 2 ; Do not use
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED                = 2 << 2
ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED_TRANSMIT_BREAK = 3 << 2
ACIA_COMMAND_RECEIVER_ECHO_DISABLED = 0 << 4
ACIA_COMMAND_RECEIVER_ECHO_ENABLED  = 1 << 4 ; Bit 2 and 3 must be zero.
ACIA_COMMAND_RECEIVER_PARITY_DISABLED = 0 << 5
ACIA_COMMAND_RECEIVER_PARITY_ENABLED  = 1 << 5 ; Parity should never be enabled
ACIA_CONTROL_PARITY_ODD                  = 0 << 6 ; Parity should never be enabled
ACIA_CONTROL_PARITY_EVEN                 = 1 << 6 ; Parity should never be enabled
ACIA_CONTROL_PARITY_MARK_CHECK_DISABLED  = 2 << 6 ; Parity should never be enabled
ACIA_CONTROL_PARITY_SPACE_CHECK_DISABLED = 3 << 6 ; Parity should never be enabled

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
  ; - Receiver IRQ on
  ; - /RTS = Low, Transmitter enabled, transmitter IRQ off
  ; - Echo mode disabled
  ; - Parity disabled
  lda # ACIA_COMMAND_DATA_TERMINAL_READY_ASSERT | ACIA_COMMAND_RECEIVER_IRQ_ENABLED | ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED | ACIA_COMMAND_RECEIVER_ECHO_DISABLED | ACIA_COMMAND_RECEIVER_PARITY_DISABLED
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
