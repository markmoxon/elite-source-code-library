\ ******************************************************************************
\
\       Name: SWAPPZERO
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused routine that swaps bytes in and out of zero page
\
\ ******************************************************************************

.SWAPPZERO

IF NOT(_APPLE_VERSION)

IF _SNG47

 LDX #&15               \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index

ELIF _COMPACT

 LDX #&16               \ This routine starts copying zero page from &0016 and
                        \ up, using X as an index

ENDIF

ELIF _APPLE_VERSION

 LDX #K3+1              \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index ???

ENDIF

.SWPZL

 LDA ZP,X               \ These instructions have no effect, as they simply swap
 LDY ZP,X               \ a byte with itself
 STA ZP,X
 STY ZP,X

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine


