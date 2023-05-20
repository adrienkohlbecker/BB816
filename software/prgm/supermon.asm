                  lda # <jmonbrk                  ; hook supermon's BRK handler to kernel BRK handler
                  sta vec_native_brk              ; note: this prevents the kernel from handling BRKs.
                  lda # >jmonbrk
                  sta vec_native_brk+1

.pc=*
*=$9000

                  !source "lib/supermon816/supermon816c.asm"

*=$ff00
vecexit           stp


*=$ff20
getcha
getchb            php
                  +x_16_bits
                  phx
                  phy
                  +x_8_bits
                  jsr acia_async_getc
                  +x_16_bits
                  ply
                  plx
                  +x_8_bits
                  bcc +
                  plp
                  sec
                  rts
+                 plp
                  clc
                  rts

*=$ff40
putcha            php
                  pha
                  +x_16_bits
                  phx
                  phy
                  +x_8_bits
-                 jsr acia_async_putc
                  bcs -
                  +x_16_bits
                  ply
                  plx
                  +x_8_bits
                  pla
                  plp
                  rts
*=$ff80
chanbctl          rts

*=.pc
