\ ******************************************************************************
\
\       Name: SWAPPZERO
\       Type: Subroutine
\   Category: Utility routines
IF NOT(_APPLE_VERSION)
\    Summary: An unused routine that swaps bytes in and out of zero page
ELIF _APPLE_VERSION
\    Summary: A routine that swaps bytes in and out of zero page
ENDIF
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

IF NOT(_APPLE_VERSION)

 LDA ZP,X               \ These instructions have no effect and are left over
 LDY ZP,X               \ from the Commodore 64 and Apple versions of Elite,
 STA ZP,X               \ where the middle two instructions point to different
 STY ZP,X               \ addresses

ELIF _APPLE_VERSION

 LDA ZP,X               \ ???
 LDY ZPSTORE,X
 STA ZPSTORE,X
 STY ZP,X

ENDIF

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine


