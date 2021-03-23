\ ******************************************************************************
\
\       Name: SIGHT
\       Type: Subroutine
\   Category: Flight
\    Summary: Draw the laser crosshairs
\
\ ******************************************************************************

.SIGHT


 LDY VIEW               \ Fetch the laser power for our new view
 LDA LASER,Y

IF _DISC_DOCKED \ Label

 BEQ BOL1-1             \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to BOL1-1 to return from the subroutine
                        \ (as BOL1-1 contains &60, which is the opcode for an
                        \ RTS)

ELIF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 BEQ LO2                \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to LO2 to return from the subroutine (as
                        \ LO2 contains an RTS)

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow in the space view

ELIF _MASTER_VERSION

 LDY #&00               \ ???
 CMP #&0F
 BEQ L7D70

 INY
 CMP #&8F
 BEQ L7D70

 INY
 CMP #&97
 BEQ L7D70

 INY

.L7D70

 LDA SIGHTCOL,Y
 STA COL

ENDIF

 LDA #128               \ Set QQ19 to the x-coordinate of the centre of the
 STA QQ19               \ screen

 LDA #Y-24              \ Set QQ19+1 to the y-coordinate of the centre of the
 STA QQ19+1             \ screen, minus 24 (because TT15 will add 24 to the
                        \ coordinate when it draws the crosshairs)

 LDA #20                \ Set QQ19+2 to size 20 for the crosshairs size
 STA QQ19+2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Platform

 JSR TT15               \ Call TT15 to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen

ELIF _6502SP_VERSION

 JSR TT15b              \ Call TT15b to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen, in the current
                        \ colour (yellow)

ENDIF

 LDA #10                \ Set QQ19+2 to size 10 for the crosshairs size
 STA QQ19+2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Platform

 JMP TT15               \ Call TT15 to draw crosshairs of size 10 at the same
                        \ location, which will remove the centre part from the
                        \ laser crosshairs, leaving a gap in the middle, and
                        \ return from the subroutine using a tail call

ELIF _6502SP_VERSION

 JMP TT15b              \ Call TT15b to draw crosshairs of size 10 at the same
                        \ location, which will remove the centre part from the
                        \ laser crosshairs, leaving a gap in the middle, and
                        \ return from the subroutine using a tail call

ENDIF

