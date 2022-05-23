# Software

## Calling conventions

- A, B, X, Y registers and C, N, V, Z, B flags are caller-saved. A subroutine may freely overwrite any of these, and the subroutine's callers have to just deal with it.
- PC, S, D, DBR, PBR registers and D, I, M, X, E flags are callee-saved. A subroutine can use them freely, but before it returns it has to put them back exactly the way it found them, and the subroutine's callers can rely on this behavior.
- A subroutine can only change bits in PORTB directly related to the hardware it is addressing (for example, a LCD subroutine can change the LCD bits but must not change the state of the other bits)
- PORTA must be returned to input, if it was set to output, and the port should be reset to zero if it was used to output data
