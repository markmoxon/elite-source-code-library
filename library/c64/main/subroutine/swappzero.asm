\ ******************************************************************************
\
\       Name: SWAPPZERO
\       Type: Subroutine
\   Category: Utility routines
\    Summary: A routine that swaps bytes in and out of zero page
\
\ ******************************************************************************

IF _GMA85_NTSC OR _GMA86_PAL

.SWAPPZERO

 LDX #K3+1              \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index ???

.SWPZL

 LDA ZP,X               \ ???
 LDY &CE00,X
 STA &CE00,X
 STY ZP,X

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine

ENDIF

