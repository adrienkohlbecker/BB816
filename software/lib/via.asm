!address IO_0_VIA_PORTB       = IO_0 + $0   ; Output/Intput Register Port B
!address IO_0_VIA_PORTA       = IO_0 + $1   ; Output/Intput Register Port A
!address IO_0_VIA_DDRB        = IO_0 + $2   ; Data Direction Register Port B
!address IO_0_VIA_DDRA        = IO_0 + $3   ; Data Direction Register Port A
!address IO_0_VIA_T1CL        = IO_0 + $4   ; T1 Low Order Latches / Counter
!address IO_0_VIA_T1CH        = IO_0 + $5   ; T1 High Order Counter
!address IO_0_VIA_T1LL        = IO_0 + $6   ; T1 Low Order Latches
!address IO_0_VIA_T1LH        = IO_0 + $7   ; T1 High Order Latches
!address IO_0_VIA_T2CL        = IO_0 + $8   ; T2 Low Order Latches / Counter
!address IO_0_VIA_T2CH        = IO_0 + $9   ; T2 High Order Counter
!address IO_0_VIA_SR          = IO_0 + $A   ; Shift Register
!address IO_0_VIA_ACR         = IO_0 + $B   ; Auxiliary Control Register
!address IO_0_VIA_PCR         = IO_0 + $C   ; Peripheral Control Register
!address IO_0_VIA_IFR         = IO_0 + $D   ; Interrupt Flag Register
!address IO_0_VIA_IER         = IO_0 + $E   ; Interrupe Enable Register
!address IO_0_VIA_PORTA_NHDSK = IO_0 + $F   ; Output/Intput Register Port A but with no handshake

VIA_PCR_CA1_NEGATIVE_EDGE             = 0 << 0
VIA_PCR_CA1_POSITIVE_EDGE             = 1 << 0
VIA_PCR_CA2_NEGATIVE_EDGE             = 0 << 1
VIA_PCR_CA2_INDEPENDENT_NEGATIVE_EDGE = 1 << 1
VIA_PCR_CA2_POSITIVE_EDGE             = 2 << 1
VIA_PCR_CA2_INDEPENDENT_POSITIVE_EDGE = 3 << 1
VIA_PCR_CA2_HANDSHAKE_OUTPUT          = 4 << 1
VIA_PCR_CA2_PULSE_OUTPUT              = 5 << 1
VIA_PCR_CA2_LOW_OUTPUT                = 6 << 1
VIA_PCR_CA2_HIGH_OUTPUT               = 7 << 1
VIA_PCR_CB1_NEGATIVE_EDGE             = 0 << 4
VIA_PCR_CB1_POSITIVE_EDGE             = 1 << 4
VIA_PCR_CB2_NEGATIVE_EDGE             = 0 << 5
VIA_PCR_CB2_INDEPENDENT_NEGATIVE_EDGE = 1 << 5
VIA_PCR_CB2_POSITIVE_EDGE             = 2 << 5
VIA_PCR_CB2_INDEPENDENT_POSITIVE_EDGE = 3 << 5
VIA_PCR_CB2_HANDSHAKE_OUTPUT          = 4 << 5
VIA_PCR_CB2_PULSE_OUTPUT              = 5 << 5
VIA_PCR_CB2_LOW_OUTPUT                = 6 << 5
VIA_PCR_CB2_HIGH_OUTPUT               = 7 << 5

VIA_ACR_PA_LATCH_DISABLE           = 0 << 0
VIA_ACR_PA_LATCH_ENABLE            = 1 << 0
VIA_ACR_PB_LATCH_DISABLE           = 0 << 1
VIA_ACR_PB_LATCH_ENABLE            = 1 << 1
VIA_ACR_SR_DISABLED                = 0 << 2
VIA_ACR_SR_SHIFT_IN_T2             = 1 << 2
VIA_ACR_SR_SHIFT_IN_PHI2           = 2 << 2
VIA_ACR_SR_SHIFT_IN_CB1            = 3 << 2
VIA_ACR_SR_SHIFT_OUT_T2_FREE       = 4 << 2
VIA_ACR_SR_SHIFT_OUT_T2            = 5 << 2
VIA_ACR_SR_SHIFT_OUT_PHI2          = 6 << 2
VIA_ACR_SR_SHIFT_OUT_CB1           = 7 << 2
VIA_ACR_T2_ONE_SHOT                = 0 << 5
VIA_ACR_T2_PB6_PULSE_COUNTER       = 1 << 5
VIA_ACR_T1_ONE_SHOT_PB7_DISABLED   = 0 << 6
VIA_ACR_T1_CONTINUOUS_PB7_DISABLED = 1 << 6
VIA_ACR_T1_ONE_SHOT_PB7_ENABLED    = 2 << 6
VIA_ACR_T1_CONTINUOUS_PB7_ENABLED  = 3 << 6

VIA_IR_CA2_ACTIVE_EDGE   = 1 << 0
VIA_IR_CA1_ACTIVE_EDGE   = 1 << 1
VIA_IR_COMPLETE_8_SHIFTS = 1 << 2
VIA_IR_CB2_ACTIVE_EDGE   = 1 << 3
VIA_IR_CB1_ACTIVE_EDGE   = 1 << 4
VIA_IR_T2_TIMEOUT        = 1 << 5
VIA_IR_T1_TIMEOUT        = 1 << 6
VIA_IR_ANY_INTERRUPT     = 1 << 7

VIA_PORT_A0_EXT0 = 1 << 0
VIA_PORT_A1_EXT1 = 1 << 1
VIA_PORT_A2_EXT2 = 1 << 2
VIA_PORT_A3_EXT3 = 1 << 3
VIA_PORT_A4_EXT4 = 1 << 4
VIA_PORT_A5_EXT5 = 1 << 5
VIA_PORT_A6_EXT6 = 1 << 6
VIA_PORT_A7_EXT7 = 1 << 7

VIA_PORT_B0_LCD_E  = 1 << 0
VIA_PORT_B1_LCD_RW = 1 << 1
VIA_PORT_B2_LCD_RS = 1 << 2
VIA_PORT_B3        = 1 << 3
VIA_PORT_B4        = 1 << 4
VIA_PORT_B5        = 1 << 5
VIA_PORT_B6        = 1 << 6
VIA_PORT_B7        = 1 << 7

VIA_PORTA_DEFAULT = $00 ; all zero
VIA_PORTB_DEFAULT = $00 ; all zero
VIA_DDRA_DEFAULT = $ff ; all outputs
VIA_DDRB_DEFAULT = $ff ; all outputs

via_init:
  ; initialize port A and port B
  lda # VIA_PORTA_DEFAULT
  sta IO_0_VIA_PORTA
  lda # VIA_PORTB_DEFAULT
  sta IO_0_VIA_PORTB
  lda # VIA_DDRA_DEFAULT
  sta IO_0_VIA_DDRA
  lda # VIA_DDRB_DEFAULT
  sta IO_0_VIA_DDRB
  ; initialize PCR: CA1, CB1 default, CA2, CB2 low output
  lda # ( VIA_PCR_CA1_NEGATIVE_EDGE | VIA_PCR_CA2_LOW_OUTPUT | VIA_PCR_CB1_NEGATIVE_EDGE | VIA_PCR_CB2_LOW_OUTPUT )
  sta IO_0_VIA_PCR
