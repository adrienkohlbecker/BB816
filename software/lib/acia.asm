; -----------------------------------------------------------------
;   Register addresses
; -----------------------------------------------------------------

!address IO_1_ACIA_DATA_REGISTER    = IO_1 + $0
!address IO_1_ACIA_STATUS_REGISTER  = IO_1 + $1
!address IO_1_ACIA_COMMAND_REGISTER = IO_1 + $2
!address IO_1_ACIA_CONTROL_REGISTER = IO_1 + $3

; -----------------------------------------------------------------
;   Status bits
; -----------------------------------------------------------------

ACIA_STATUS_PARITY_ERROR_DETECTED           = 1 << 0
ACIA_STATUS_FRAMING_ERROR_DETECTED          = 1 << 1
ACIA_STATUS_OVERRUN_HAS_OCCURRED            = 1 << 2
ACIA_STATUS_RECEIVER_DATA_REGISTER_FULL     = 1 << 3
ACIA_STATUS_TRANSMITTER_DATA_REGISTER_EMPTY = 1 << 4
ACIA_STATUS_DATA_CARRIER_DETECT_HIGH        = 1 << 5
ACIA_STATUS_DATA_SET_READY_HIGH             = 1 << 6
ACIA_STATUS_INTERRUPT_OCCURRED              = 1 << 7

; -----------------------------------------------------------------
;   Control bits
; -----------------------------------------------------------------

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

; -----------------------------------------------------------------
;   Command bits
; -----------------------------------------------------------------

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

!ifdef FLAG_ACIA_IRQ {
  !ifdef FLAG_ACIA_XMIT_BUG {
    ; enable receiver IRQ,  enable transmitter but not its IRQs
    !set .command_irq_bits = ACIA_COMMAND_RECEIVER_IRQ_ENABLED | ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED
  } else {
    ; enable receiver IRQ, disable transmitter until something to transmit is available
    !set .command_irq_bits = ACIA_COMMAND_RECEIVER_IRQ_ENABLED | ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_DEASSERT_TRANSMITTER_DISABLED
  }
} else {
  ; disable receiver IRQ, enable transmitter but not its IRQs
  !set .command_irq_bits = ACIA_COMMAND_RECEIVER_IRQ_DISABLED | ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_DISABLED
}

; -----------------------------------------------------------------
;   Baud rate setting
; -----------------------------------------------------------------

!if ACIA_BAUD = 300 { ; note: 300 is the smallest supported by the MCP2221A
  .baud_bits = ACIA_CONTROL_BAUD_RATE_300
} else if ACIA_BAUD = 600 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_600
} else if ACIA_BAUD = 1200 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_1200
} else if ACIA_BAUD = 1800 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_1800
} else if ACIA_BAUD = 2400 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_2400
} else if ACIA_BAUD = 3600 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_3600
} else if ACIA_BAUD = 4800 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_4800
} else if ACIA_BAUD = 7200 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_7200
} else if ACIA_BAUD = 9600 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_9600
} else if ACIA_BAUD = 19200 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_19200
} else if ACIA_BAUD = 115200 {
  .baud_bits = ACIA_CONTROL_BAUD_RATE_115200
} else {
  !serious "Invalid baud rate selected"
}

; -----------------------------------------------------------------
;   Workspace
; -----------------------------------------------------------------

!address rx_buffer_rptr = $0200 ; 1 byte
!address rx_buffer_wptr = $0201 ; 1 byte
!address rx_buffer      = $0202 ; 16 bytes
rx_buffer_size = 16

!address tx_buffer_rptr = $0212 ; 1 byte
!address tx_buffer_wptr = $0213 ; 1 byte
!address tx_buffer      = $0214 ; 16 bytes
tx_buffer_size = 16

; -----------------------------------------------------------------
;   acia_init(): Programatically resets and initializes the ACIA as well as the internal workspace.
; -----------------------------------------------------------------

acia_init         stz IO_1_ACIA_STATUS_REGISTER   ; programmatically reset the chip by writing the status register
                                                  ; weirdly enough, that does not reset ALL the internal registers,
                                                  ; see the datasheet.

                  stz rx_buffer_rptr              ; reset internal state
                  stz rx_buffer_wptr
                  stz tx_buffer_rptr
                  stz tx_buffer_wptr

                  ldx # rx_buffer_size - 1        ; zero out the rx buffer
-                 stz rx_buffer,X
                  dex
                  bpl -

                  ldx # tx_buffer_size - 1        ; zero out the tx buffer
-                 stz tx_buffer,X
                  dex
                  bpl -

                                                  ; set up the ACIA with
                                                  ; - baud rate
                                                  ; - no external receiver clock, RxC pin outputs the baud rate
                                                  ; - 8 bit word length
                                                  ; - 1 stop bit
                  lda # .baud_bits | ACIA_CONTROL_RECEIVER_CLOCK_BAUD_RATE | ACIA_CONTROL_WORD_LENGTH_8 | ACIA_CONTROL_STOPBIT_1
                  sta IO_1_ACIA_CONTROL_REGISTER

                                                  ; further set up the ACIA with
                                                  ; - /DTR = Low
                                                  ; - IRQ bits from FLAG_ACIA_IRQ
                                                  ; - Echo mode disabled
                                                  ; - Parity disabled
                  lda # ACIA_COMMAND_DATA_TERMINAL_READY_ASSERT | .command_irq_bits | ACIA_COMMAND_RECEIVER_ECHO_DISABLED | ACIA_COMMAND_RECEIVER_PARITY_DISABLED
                  sta IO_1_ACIA_COMMAND_REGISTER

                  rts

; -----------------------------------------------------------------
;   acia_sync_putc(): Sends a byte over serial. Blocking loop until transmit is available.
;
;   Parameters:
;       A = byte to send
; -----------------------------------------------------------------

acia_sync_putc    !ifdef FLAG_ACIA_IRQ {

-                   jsr acia_async_putc
                    bcs -

                  } else {

                    tax                           ; move byte to X register

                    !ifndef FLAG_ACIA_XMIT_BUG {  ; if we're using an ACIA without the Xmit bug (eg. R6551)
                                                  ; wait until we can transmit
                      lda # ACIA_STATUS_TRANSMITTER_DATA_REGISTER_EMPTY
-                     bit IO_1_ACIA_STATUS_REGISTER
                      beq -
                    }

                    stx IO_1_ACIA_DATA_REGISTER   ; transmit byte

                    !ifdef FLAG_ACIA_XMIT_BUG {   ; if we're using an ACIA with the Xmit bug (eg. W65C51N)
                                                  ; wait for the byte to be transmitted
                                                  ; With a 8N1 configuration, 10 bits need to go out per byte
                                                  ; Example: At 300 baud, that's 1/30s per byte
                      +delay_ms 1000*10.0/ACIA_BAUD
                    }

                  }

                  rts

; -----------------------------------------------------------------
;   acia_async_putc(): Enqueue the A register in the Tx buffer if there is space, and set the carry.
;                      If there is no space, clear the carry.
;
;   Parameters:
;       A: byte to enqueue
;
;   Returns:
;       P:c=0 if byte enqueued, c=1 no space in buffer
; -----------------------------------------------------------------

acia_async_putc   !ifdef FLAG_ACIA_IRQ {

                    !ifdef FLAG_ACIA_XMIT_BUG {

                                                  ; if we're using an ACIA with the Xmit bug (eg. W65C51N)
                                                  ; wait for the byte to be transmitted
                                                  ; With a 8N1 configuration, 10 bits need to go out per byte
                                                  ; Example: At 300 baud, that's 1/30s per byte
                      sta IO_1_ACIA_DATA_REGISTER
                      +delay_ms 1000*10.0/ACIA_BAUD

                    } else {

                      ldx tx_buffer_wptr          ; get write pointer

                      txy                         ; check if our buffer is full
                      iny                         ; if wptr + 1 == rptr, then writing this byte will make the two
                      cpy tx_buffer_rptr          ; pointers equal, which is the "no data" case, so this constitutes
                      bne +                       ; an overflow.
                      sec                         ; in that case, clear carry and return
                      rts

+                     sta tx_buffer,X             ; else add data byte to tx buffer

                      cpx # tx_buffer_size - 1    ; check if write pointer = tx_buffer_size - 1
                      bne +                       ; if yes, set it to FF so it wraps to 0 with the increment
                      ldx # $ff
+
                      inx                         ; increment and save new pointer
                      stx tx_buffer_wptr

                      xba                         ; save byte for return
                                                  ; enable transmitter if it is not already enabled
                      lda # ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_ENABLED
                      tsb IO_1_ACIA_COMMAND_REGISTER
                      xba                         ; restore byte

                    }

                  } else {

                    jsr acia_sync_putc

                  }

                  clc                             ; clear carry and return
                  rts

; -----------------------------------------------------------------
;   acia_sync_getc(): Receives a byte over serial. Blocking loop until something is received.
;
;   Returns:
;       A: byte received
;       P: n,z set from A
; -----------------------------------------------------------------
acia_sync_getc    !ifdef FLAG_ACIA_IRQ {

-                   jsr acia_async_getc
                    bcs -

                  } else {

                    ; TODO: Check for error conditions (parity, overrun, framing)
                    lda # ACIA_STATUS_RECEIVER_DATA_REGISTER_FULL
-                   bit IO_1_ACIA_STATUS_REGISTER ; wait until a byte is available
                    beq -

                    lda IO_1_ACIA_DATA_REGISTER   ; get received byte

                  }

                  rts

; -----------------------------------------------------------------
;   acia_async_getc(): If a byte has been received over serial, return it in the A register and set the carry.
;                      If not, clear the carry.
;
;   Returns:
;       A: byte received
;       P: n,z set from A
;          c=0 if byte received, c=1 if no byte received
; -----------------------------------------------------------------

acia_async_getc   !ifdef FLAG_ACIA_IRQ {

                    ldx rx_buffer_rptr            ; compare r/w pointers
                    cpx rx_buffer_wptr
                    bne +                         ; if the two pointers are equal, no byte has been received
                    sec                           ; clear carry and return
                    rts

+                   lda rx_buffer,X               ; else, load the received byte

                    cpx # rx_buffer_size - 1      ; check if read pointer = rx_buffer_size - 1 and reset if yes, if not increment
                    bne +                         ; if not, just increment
                    ldx # $ff                     ; if yes, reset it to $ff and increment (effectively set it to 0)
+                   inx

                    stx rx_buffer_rptr            ; save new pointer

                    and # $ff                     ; ensure flags are set by the value of A

                  } else {

                    jsr acia_sync_getc

                  }

                  clc                             ; set carry to signify a byte is present
                  rts


!ifdef FLAG_ACIA_IRQ {

; -----------------------------------------------------------------
;   acia_int_handler(): Check if the ACIA has raised an interrupt, and if yes process it using the procedure
;                            outline in Rockwell's R6551 datasheet "Status Register Operation"
; -----------------------------------------------------------------

acia_int_handler  lda IO_1_ACIA_STATUS_REGISTER
                  bmi +                           ; n flag is set to ACIA_STATUS_INTERRUPT_OCCURRED by lda.
                  rts                             ; If it is 1, an ACIA interrupt occurred, else we return
+
                  bit # ACIA_STATUS_RECEIVER_DATA_REGISTER_FULL
                  beq +
                  jsr .acia_int_rx
+
                  !ifndef FLAG_ACIA_XMIT_BUG {    ; if we're using an ACIA without the Xmit bug (eg. R6551)
                    bit # ACIA_STATUS_TRANSMITTER_DATA_REGISTER_EMPTY
                    beq +
                    jsr .acia_int_tx
                  }
+
                  rts

; -----------------------------------------------------------------
;   .acia_int_rx(): Handle a receiver interrupt.
;
;   Parameters:
;       A = ACIA status register at time of interrupt
; -----------------------------------------------------------------

.acia_int_rx      ldy IO_1_ACIA_DATA_REGISTER     ; load data register, this will clear the interrupt
                                                  ; as well as the status register bits

                  bit # ACIA_STATUS_OVERRUN_HAS_OCCURRED
                  bne .acia_handle_overrun

                  bit # ACIA_STATUS_FRAMING_ERROR_DETECTED
                  bne .acia_handle_framing_error

                  bit # ACIA_STATUS_PARITY_ERROR_DETECTED
                  bne .acia_handle_parity_error

                  ldx rx_buffer_wptr              ; get write pointer

                  txa                             ; check if our buffer is full
                  inc                             ; if wptr + 1 == rptr, then writing this byte will make the two
                  cmp rx_buffer_rptr              ; pointers equal, which is the "no data" case, so this constitutes
                  beq .acia_handle_rx_buffer_overflow ; an overflow.

                  tya                             ; add data byte to rx buffer
                  sta rx_buffer,X

                  cpx # rx_buffer_size - 1        ; check if write pointer = rx_buffer_size - 1
                  bne +                           ; if yes, set it to FF so it wraps to 0 with the increment
                  ldx # $ff
+
                  inx                             ; increment and save new pointer
                  stx rx_buffer_wptr

                  rts

.acia_handle_overrun
.acia_handle_framing_error
.acia_handle_parity_error
.acia_handle_rx_buffer_overflow
                  rts                             ; don't handle these errors for now

; -----------------------------------------------------------------
;   .acia_int_tx(): Handle a transmitter interrupt.
; -----------------------------------------------------------------

.acia_int_tx                                      ; do we have data to transmit
                  ldx tx_buffer_rptr              ; compare r/w pointers
                  cpx tx_buffer_wptr
                  bne +                           ; if they're not equal, we have data to send
                                                  ; else we're done with the queue
                  lda # ACIA_COMMAND_TRANSMITTER_CONTROL_REQUEST_TO_SEND_ASSERT_INTERRUPT_ENABLED
                  trb IO_1_ACIA_COMMAND_REGISTER  ; disable transmitter
                  rts
+
                  lda tx_buffer,x
                  sta IO_1_ACIA_DATA_REGISTER

                  cpx # tx_buffer_size - 1        ; check if read pointer = tx_buffer_size - 1
                  bne +                           ; if yes, set it to FF so it wraps to 0 with the increment
                  ldx # $ff
+
                  inx                             ; increment and save new pointer
                  stx tx_buffer_rptr

                  rts

}
