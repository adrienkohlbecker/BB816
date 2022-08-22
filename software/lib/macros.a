CPU_SPEED_MHZ = 4.0
CPU_PERIOD_NS = 1000.0 / CPU_SPEED_MHZ

; delay_small_us can represent delays from 6 cycles (1.5us @ 4MHz) to 1026 cycles (256.5us @ 4MHz), in steps of 4 cycles (1us @ 4MHz)
!macro delay_small_us .delay_us {
  !if .delay_us > 1026 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_small_us can only wait maximum 1026 cycles, use +delay_medium_us"
  }
  !if .delay_us < 6 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_small_us can only wait at least 6 cycles, use NOPs"
  }

  ; cycles = 2 (ldx w/X=1) + @loops * ( 2 (dex) + 2 (bne) ) = 2+4*@loops
  ; cycles = .delay_us * 1000.0/CPU_PERIOD_NS
  ; => @loops = ( .delay_us * 1000.0/CPU_PERIOD_NS - 2 ) / 4
  ; add 0.99 to round up
  @loops = int( ( .delay_us * 1000.0/CPU_PERIOD_NS - 2 ) / 4 + 0.99 )

  ldx # @loops - 1
- dex
  bne -
}

; delay_medium_us can represent delays from 12 cycles (3us @ 4MHz) to 263682 cycles (65920.5us ~= 65.92ms @ 4MHz), in steps of 4 cycles (1us @ 4MHz)
!macro delay_medium_us .delay_us {
  !if .delay_us <= 1026 * CPU_PERIOD_NS / 1000.0 {
    !warn "+delay_medium_us used where +delay_small_us could be used"
  }
  !if .delay_us > 263682 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_medium_us can only wait maximum 263682 cycles, use +delay_large_ms"
  }
  !if .delay_us < 12 * CPU_PERIOD_NS / 1000.0 {
    !error "+delay_medium_us can only wait at least 12 cyles, use +delay_small_us"
  }

  ; cycles = 2 (ldy w/X=1) + @loops_Y * ( 2 (ldx w/X=1) + @loops_X * ( 2 (dex) + 2 (bne) ) + 2 (dey) + 2 (bne) ) = 2+Y*(6+X*4)
  ; cycles = .delay_us * 1000.0/CPU_PERIOD_NS
  ; assuming a maximum X = 256
  ; Y = (cycles - 2) / (6 + 256*4) = (cycles - 2) / 1030
  ; add 0.99 to round up
  @loops_Y = int( (.delay_us * 1000.0/CPU_PERIOD_NS - 2) / 1030 + 0.99 )
  ; now we can do X
  ; X = ( (cycles - 2) / Y - 6 ) / 4
  ; add 0.99 to round up
  @loops_X = int( ( (.delay_us * 1000.0/CPU_PERIOD_NS - 2) / @loops_Y - 6 ) / 4 + 0.99 )

  ldy # @loops_Y - 1
-- ldx # @loops_X - 1
- dex
  bne -
  dey
  bne --
}

; delay_large_ms can represent delays from 18 cycles (4.5us @ 4MHz) to 67241478 cycles (~= 16.81s @ 4MHz), in steps of 4 cycles (1us @ 4MHz)
!macro delay_large_ms .delay_ms {
  !if .delay_ms <= 263682 * CPU_PERIOD_NS / 1000000.0 {
    !warn "+delay_large_ms used where +delay_medium_ms could be used"
  }
  !if .delay_ms > 67241478 * CPU_PERIOD_NS / 1000000.0 {
    !error "+delay_large_ms can only wait maximum 67241478 cycles, use multiple calls"
  }
  !if .delay_ms < 18 * CPU_PERIOD_NS / 1000000.0 {
    !error "+delay_large_ms can only wait at least 18 cycles, use +delay_small_us"
  }

  ; cycles = 2 (lda w/M=1) + @loops_A * ( 2 (ldy w/X=1) + @loops_Y * ( 2 (ldx w/X=1) + @loops_X * ( 2 (dex) + 2 (bne) ) + 2 (dey) + 2 (bne) ) + 2 (dec) + 2 (bne) )
  ; cycles = 6 + A * ( 6 + Y * ( 2 + X*4 ))
  ; cycles = .delay_ms * 1000000.0/CPU_PERIOD_NS
  ; assuming a maximum X = Y = 256
  ; A = ( cycles - 6 ) / 262662
  ; add 0.99 to round up
  @loops_A = int( ( .delay_ms * 1000000.0/CPU_PERIOD_NS - 6 ) / 262662 + 0.99 )
  ; assuming a maximum X = 256
  ; Y = ( ( cycles - 6 ) / A - 6 ) / 1026
  ; add 0.99 to round up
  @loops_Y = int( ( ( .delay_ms * 1000000.0/CPU_PERIOD_NS - 6) / @loops_A - 6 ) / 1026 + 0.99  )
  ; finally, we can compute X
  ; X = ( ( ( cycles - 6 ) / A - 6 ) / Y - 2 ) / 4
  ; add 0.99 to round up
  @loops_X = int( ( ( ( .delay_ms * 1000000.0/CPU_PERIOD_NS - 6 ) / @loops_A - 6 ) / @loops_Y - 2 ) / 4 + 0.99)

  lda # @loops_A - 1
--- ldy # @loops_Y - 1
-- ldx # @loops_X - 1
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
