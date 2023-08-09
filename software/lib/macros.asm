; -----------------------------------------------------------------
;   cpu_emu / cpu_native: manage the CPU emulation mode setting
; -----------------------------------------------------------------

!macro cpu_native {
                  clc
                  xce
}

!macro cpu_emu {
                  sec
                  xce
}

; -----------------------------------------------------------------
;   +brk:         brk is a two byte instruction, we have to add a signature byte for the program
;                 to resume correctly after rti occurs.
; -----------------------------------------------------------------

!macro brk {
                  brk
                  !byte $00
}

; -----------------------------------------------------------------
;   mx_16_bits / mx_8_bits: manage the accumulator and index register sizes
; -----------------------------------------------------------------

!macro mx_16_bits {
                  rep # %00110000
                  !rl
                  !al
}

!macro mx_8_bits {
                  sep # %00110000
                  !rs
                  !as
}

; -----------------------------------------------------------------
;   m_16_bits / m_8_bits: manage the accumulator register size
; -----------------------------------------------------------------

!macro m_16_bits {
                  rep #%00100000
                  !al
}

!macro m_8_bits {
                  sep #%00100000
                  !as
}

; -----------------------------------------------------------------
;   x_16_bits / x_8_bits: manage the index register size
; -----------------------------------------------------------------

!macro x_16_bits {
                  rep #%00010000
                  !rl
}

!macro x_8_bits {
                  sep #%00010000
                  !rs
}

; -----------------------------------------------------------------
;  bne_long: bne to a far label
; -----------------------------------------------------------------

!macro bne_long .label {
                  beq +
                  brl .label
+
}

; -----------------------------------------------------------------
;  delay_us: delay loop macro
; -----------------------------------------------------------------

!macro delay_us .delay_us {

                  !if .delay_us > 83298577 * CPU_SPEED_MHZ {

                      !error "+delay_large_ms can only wait maximum 83298577 cycles, use multiple calls"

                  } else if .delay_us < 39 / CPU_SPEED_MHZ {

                    ; add as many nops as needed, round delay up to a multiple of 2 cycles
                    !for i, 0, int(.delay_us * CPU_SPEED_MHZ / 2) {
                      nop
                    }

                  } else {

                    ; cycles = 3 [pha] + 3 [phy] + 3 [phx] +  2 [lda w/M=1] + @loops_A * (
                    ;             2 [ldy w/X=1] + @loops_Y * (
                    ;                2 [ldx w/X=1] + @loops_X * (
                    ;                   2 [dex] + 3 [bne w/branch taken]
                    ;                ) - 1 [not taking last bne branch] + 2 [dey] + 3 [bne w/branch taken]
                    ;             ) - 1 [not taking last bne branch] + 2 [dec] + 3 [bne w/branch taken]
                    ;          ) - 1 [not taking last bne branch] + 4 [pla] + 4 [ply] + 4 [plx]
                    ; cycles = 22 + A * ( 6 + Y * ( 6 + X*5 ))
                    ; cycles = .delay_us * CPU_SPEED_MHZ
                    ; assuming a maximum X = Y = 255
                    ; A = ( cycles - 22 ) / 326661
                    @loops_A_f = ( .delay_us * CPU_SPEED_MHZ - 22 ) / 326661
                    !if (@loops_A_f = 0 | @loops_A_f > int(@loops_A_f)) { @loops_A = int(@loops_A_f) + 1 } else { @loops_A = int(@loops_A_f) } ; round up

                    ; then, assuming a maximum X = 255
                    ; Y = ( ( cycles - 22 ) / A - 6 ) / 1281
                    @loops_Y_f = ( ( .delay_us * CPU_SPEED_MHZ - 22) / @loops_A - 6 ) / 1281
                    !if (@loops_Y_f = 0 | @loops_Y_f > int(@loops_Y_f)) { @loops_Y = int(@loops_Y_f) + 1 } else { @loops_Y = int(@loops_Y_f) } ; round up

                    ; finally, we can compute X
                    ; X = ( ( ( cycles - 22 ) / A - 6 ) / Y - 6 ) / 5
                    @loops_X_f = ( ( ( .delay_us * CPU_SPEED_MHZ - 22 ) / @loops_A - 6 ) / @loops_Y - 6 ) / 5
                    !if (@loops_X_f = 0 | @loops_X_f > int(@loops_X_f)) { @loops_X = int(@loops_X_f) + 1 } else { @loops_X = int(@loops_X_f) } ; round up


                    pha
                    phy
                    phx

                    lda # @loops_A
---                 ldy # @loops_Y
--                  ldx # @loops_X
-                   dex
                    bne -
                    dey
                    bne --
                    dec
                    bne ---

                    plx
                    ply
                    pla

                  }

}

; -----------------------------------------------------------------
;  delay_ms: delay loop macro
; -----------------------------------------------------------------

!macro delay_ms .delay_ms {
                  +delay_us .delay_ms * 1000.0
}
