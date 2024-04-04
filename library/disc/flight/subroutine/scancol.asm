\ ******************************************************************************
\
\       Name: SCANCOL
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Set the correct colour on the scanner for the current ship type
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The ship type that we are showing on the scanner
\
\ ******************************************************************************

IF _SRAM_DISC

.SCANCOL

 LDX #&F0               \ Set X to the default scanner colour of red (a 4-pixel
                        \ mode 5 byte in colour 2)

 CMP #MSL               \ If the ship type in A is that of a missile, then jump
 BEQ scol1              \ to scol1 to return from the subroutine with the colour
                        \ set to red

 LDX #&FF               \ Set X to the default scanner colour of green/cyan
                        \ (a 4-pixel mode 5 byte in colour 3)

 CMP #SHU               \ If the ship type in A is that of a Shuttle or greater,
 BCS scol1              \ then it is a ship, so jump to scol1 to return from the
                        \ subroutine with the colour set to green/cyan

 LDX #&0F               \ Otherwise set X to the default scanner colour of
                        \ yellow/white (a 4-pixel mode 5 byte in colour 1), to
                        \ use as the scanner colour for the space station,
                        \ asteroids, escape pods and cargo

.scol1

 RTS                    \ Return from the subroutine

 NOP                    \ This code is never run, and just pads out the DEEOR
 NOP                    \ routine in the sideways RAM variant to be the same
 NOP                    \ size as in the original version (the sideways RAM
 NOP                    \ variant is not encrypted, so the decryption routine
 NOP                    \ is disabled and is replaced by NOPs and the SCANCOL
 JMP RSHIPS             \ routine)

ENDIF

