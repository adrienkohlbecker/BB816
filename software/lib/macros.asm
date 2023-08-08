CPU_SPEED_MHZ = 4.0
CPU_PERIOD_NS = 1000.0 / CPU_SPEED_MHZ

; delay_small_us can represent delays from 6 cycles (1.5us @ 4MHz) to 1276 cycles (319us @ 4MHz), in steps of 5 cycles (1.25us @ 4MHz)
!macro delay_small_us .delay_us {
  !if .delay_us > 1276 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_small_us can only wait maximum 1276 cycles, use +delay_medium_us"
  }
  !if .delay_us < 6 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_small_us can only wait at least 6 cycles, use NOPs"
  }

  ; cycles = 2 [ldx w/X=1] + @loops * ( 2 [dex] + 3 [bne w/branch taken] ) - 1 [not taking last bne branch]
  ; => cycles = 1 + 5 * @loops
  ; cycles = .delay_us * 1000.0/CPU_PERIOD_NS
  ; => @loops = ( .delay_us * 1000.0/CPU_PERIOD_NS - 1 ) /
  @loops_f = ( .delay_us * 1000.0/CPU_PERIOD_NS - 1 ) / 5
  !if (@loops_f > int(@loops_f)) { @loops = int(@loops_f) + 1 } else { @loops = int(@loops_f) } ; round up

  ldx # @loops
- dex
  bne -
}

; delay_medium_us can represent delays from 12 cycles (3us @ 4MHz) to 326656 cycles (81664us ~= 81.6ms @ 4MHz)
; the step size increases with the size of the delay
!macro delay_medium_us .delay_us {
  !if .delay_us <= 1281 * CPU_PERIOD_NS / 1000.0 {
    !warn "+delay_medium_us used where +delay_small_us could be used"
  }
  !if .delay_us > 326656 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_medium_us can only wait maximum 326656 cycles, use +delay_large_ms"
  }
  !if .delay_us < 12 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_medium_us can only wait at least 12 cyles, use +delay_small_us"
  }

  ; cycles = 2 [ldy w/X=1] + @loops_Y * ( 2 [ldx w/X=1] + @loops_X * ( 2 [dex] + 3 [bne w/branch taken] ) - 1 [not taking last bne branch] + 2 [dey] + 3 [bne w/branch taken ) - 1 [not taking last bne branch]
  ; => cycles = 1 + @loops_Y * (6 + loops_X * 5)
  ; cycles = .delay_us * 1000.0/CPU_PERIOD_NS
  ; assuming a maximum X = 255
  ; Y = (cycles - 1) / (6 + 255*5) = (cycles - 1) / 1281
  @loops_Y_f = (.delay_us * 1000.0/CPU_PERIOD_NS - 1) / 1281
  !if (@loops_Y_f > int(@loops_Y_f)) { @loops_Y = int(@loops_Y_f) + 1 } else { @loops_Y = int(@loops_Y_f) } ; round up

  ; now we can do X
  ; X = ( (cycles - 1) / Y - 6 ) / 5
  @loops_X_f = ( (.delay_us * 1000.0/CPU_PERIOD_NS - 1) / @loops_Y - 6 ) / 5
  !if (@loops_X_f > int(@loops_X_f)) { @loops_X = int(@loops_X_f) + 1 } else { @loops_X = int(@loops_X_f) } ; round up

  ldy # @loops_Y
-- ldx # @loops_X
- dex
  bne -
  dey
  bne --
}

; delay_large_ms can represent delays from 18 cycles (4.5us @ 4MHz) to 83298556 cycles (~= 20.82s @ 4MHz)
; the step size increases with the size of the delay
!macro delay_large_ms .delay_ms {
  !if .delay_ms <= 329217 * CPU_PERIOD_NS / 1000000.0 {
    !warn "+delay_large_ms used where +delay_medium_ms could be used"
  }
  !if .delay_ms > 83298556 * CPU_PERIOD_NS / 1000000.0 {
    !error "+delay_large_ms can only wait maximum 83298556 cycles, use multiple calls"
  }
  !if .delay_ms < 18 * CPU_PERIOD_NS / 1000000.0 {
    !error "+delay_large_ms can only wait at least 18 cycles, use +delay_small_us"
  }

  ; cycles = 2 [lda w/M=1] + @loops_A * ( 2 [ldy w/X=1] + @loops_Y * ( 2 [ldx w/X=1] + @loops_X * ( 2 [dex] + 3 [bne w/branch taken] ) - 1 [not taking last bne branch] + 2 [dey] + 3 [bne w/branch taken] ) - 1 [not taking last bne branch] + 2 [dec] + 3 [bne w/branch taken] ) - 1 [not taking last bne branch]
  ; cycles = 1 + A * ( 6 + Y * ( 6 + X*5 ))
  ; cycles = .delay_ms * 1000000.0/CPU_PERIOD_NS
  ; assuming a maximum X = Y = 255
  ; A = ( cycles - 1 ) / 326661
  @loops_A_f = ( .delay_ms * 1000000.0/CPU_PERIOD_NS - 1 ) / 326661
  !if (@loops_A_f > int(@loops_A_f)) { @loops_A = int(@loops_A_f) + 1 } else { @loops_A = int(@loops_A_f) } ; round up
  ; then, assuming a maximum X = 255
  ; Y = ( ( cycles - 1 ) / A - 6 ) / 1281
  @loops_Y_f = ( ( .delay_ms * 1000000.0/CPU_PERIOD_NS - 1) / @loops_A - 6 ) / 1281
  !if (@loops_Y_f > int(@loops_Y_f)) { @loops_Y = int(@loops_Y_f) + 1 } else { @loops_Y = int(@loops_Y_f) } ; round up
  ; finally, we can compute X
  ; X = ( ( ( cycles - 1 ) / A - 6 ) / Y - 6 ) / 5
  @loops_X_f = ( ( ( .delay_ms * 1000000.0/CPU_PERIOD_NS - 1 ) / @loops_A - 6 ) / @loops_Y - 6 ) / 5
  !if (@loops_X_f > int(@loops_X_f)) { @loops_X = int(@loops_X_f) + 1 } else { @loops_X = int(@loops_X_f) } ; round up

  lda # @loops_A
--- ldy # @loops_Y
-- ldx # @loops_X
- dex
  bne -
  dey
  bne --
  dec
  bne ---
}

!macro delay_medium_ms .delay_ms {
  +delay_medium_us .delay_ms * 1000
}

!macro cpu_native {
  clc
  xce
}

!macro cpu_emu {
  sec
  xce
}

// brk is a two byte instruction, we have to add
// a signature byte for the program to resume
// correctly after rti occurs.
!macro brk {
  brk
  !byte $00
}

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

!macro m_16_bits {
  rep #%00100000
  !al
}

!macro m_8_bits {
  sep #%00100000
  !as
}

!macro x_16_bits {
  rep #%00010000
  !rl
}

!macro x_8_bits {
  sep #%00010000
  !rs
}
