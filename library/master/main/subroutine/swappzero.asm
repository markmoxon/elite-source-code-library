\ ******************************************************************************
\
\       Name: SWAPPZERO
\       Type: Subroutine
\   Category: Utility routines
IF NOT(_C64_VERSION OR _APPLE_VERSION)
\    Summary: An unused routine that swaps bytes in and out of zero page
ELIF _C64_VERSION OR _APPLE_VERSION
\    Summary: Aroutine that swaps bytes in and out of zero page
ENDIF
\
\ ******************************************************************************

.SWAPPZERO

IF NOT(_C64_VERSION OR _APPLE_VERSION)

IF _SNG47

 LDX #&15               \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index

ELIF _COMPACT

 LDX #&16               \ This routine starts copying zero page from &0016 and
                        \ up, using X as an index

ENDIF

.SWPZL

 LDA ZP,X               \ These instructions have no effect, though they look
 LDY ZP,X               \ like they may have been used to swap two sets of bytes
 STA ZP,X               \ within zero page
 STY ZP,X

ELIF _APPLE_VERSION

 LDX #K3+1              \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index ???

.SWPZL

 LDA 0,X                \ ???
 LDY ZPSTORE,X
 STA ZPSTORE,X
 STY 0,X

ENDIF

IF NOT(_C64_VERSION)

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

IF _GMA85_NTSC OR _GMA86_PAL

 LDX #K3+1              \ This routine starts copying zero page from &0015 and
                        \ up, using X as an index ???

.SWPZL

 LDA 0,X                \ ???
 LDY &CE00,X
 STA &CE00,X
 STY 0,X

 INX                    \ Increment the loop counter

 BNE SWPZL              \ Loop back for the next byte

 RTS                    \ Return from the subroutine

ENDIF

ENDIF

