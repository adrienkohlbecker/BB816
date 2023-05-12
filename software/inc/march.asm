; Implement March SS test
;
; Source:
; March SS: A Test for All Static Simple RAM Faults
; by Said Hamdioui, Ad J. van de Goor, Mike Rodgers
; http://ce-publications.et.tudelft.nl/publications/1107_march_ss_a_test_for_all_static_simple_ram_faults.pdf
;
; 1. ⇕(w0)
; 2. ⇑(r0,r0,w0,r0,w1)
; 3. ⇑(r1,r1,w1,r1,w0)
; 4. ⇓(r0,r0,w0,r0,w1)
; 5. ⇓(r1,r1,w1,r1,w0)
; 6. ⇕(r0)
;
; Invocation:
;    !set .start = address($0000)
;    !set .end = address($ffff)
;    !set .fail = address(.failure_handler)
;    !source "inc/march.asm"

                  +mx_16_bits                     ; switch to 16 bits registers
                  ldx # 0

-                 stz .start,x
                  inx
                  inx
                  cpx # int(.end)+1 & $ffff
                  bne -

                  ldx # 0

-                 lda .start,x
                  +bne_long +
                  lda .start,x
                  +bne_long +
                  stz .start,x
                  lda .start,x
                  +bne_long +
                  lda # $ffff
                  sta .start,x
                  inx
                  inx
                  cpx # int(.end)+1 & $ffff
                  bne -

                  ldx # 0

-                 lda .start, x
                  cmp # $ffff
                  bne +
                  lda .start, x
                  cmp # $ffff
                  bne +
                  sta .start, x
                  lda .start, x
                  cmp # $ffff
                  bne +
                  stz .start, x
                  inx
                  inx
                  cpx # int(.end)+1 & $ffff
                  bne -

                  ldx # int(.end-1)

-                 lda .start,x
                  bne +
                  lda .start,x
                  bne +
                  stz .start,x
                  lda .start,x
                  bne +
                  lda # $ffff
                  sta .start,x
                  dex
                  dex
                  bne -

                  ldx # int(.end-1)

-                 lda .start, x
                  cmp # $ffff
                  bne +
                  lda .start, x
                  cmp # $ffff
                  bne +
                  sta .start, x
                  lda .start, x
                  cmp # $ffff
                  bne +
                  stz .start, x
                  dex
                  dex
                  bne -

                  ldx # int(.end-1)

-                 lda .start, x
                  bne +
                  dex
                  dex
                  bne -

                  bra ++

+                 +mx_8_bits                      ; restore register sizes
                  bra .fail

++                +mx_8_bits                      ; restore register sizes
