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

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Label

 BEQ BOL1-1             \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to BOL1-1 to return from the subroutine
                        \ (as BOL1-1 contains &60, which is the opcode for an
                        \ RTS)

ELIF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 BEQ LO2                \ If it is zero (i.e. there is no laser fitted to this
                        \ view), jump to LO2 to return from the subroutine (as
                        \ LO2 contains an RTS)

ENDIF

IF _6502SP_VERSION \ Master: In the Master version, the laser crosshairs are different colours for the different laser types

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow in the space view

ELIF _MASTER_VERSION

 LDY #0                 \ Set Y to 0, to represent a pulse laser

 CMP #POW               \ If the laser power in A is equal to a pulse laser,
 BEQ SIG1               \ jump to SIG1 with Y = 0

 INY                    \ Increment Y to 1, to represent a beam laser

 CMP #(POW+128)         \ If the laser power in A is equal to a beam laser,
 BEQ SIG1               \ jump to SIG1 with Y = 1

 INY                    \ Increment Y to 2, to represent a military laser

 CMP #Armlas            \ If the laser power in A is equal to a military laser,
 BEQ SIG1               \ jump to SIG1 with Y = 2

 INY                    \ Increment Y to 3, to represent a mining laser

.SIG1

 LDA SIGHTCOL,Y         \ Set the colour from the SIGHTCOL table
 STA COL

ENDIF

 LDA #128               \ Set QQ19 to the x-coordinate of the centre of the
 STA QQ19               \ screen

 LDA #Y-24              \ Set QQ19+1 to the y-coordinate of the centre of the
 STA QQ19+1             \ screen, minus 24 (because TT15 will add 24 to the
                        \ coordinate when it draws the crosshairs)

 LDA #20                \ Set QQ19+2 to size 20 for the crosshairs size
 STA QQ19+2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

 JSR TT15               \ Call TT15 to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen

ELIF _6502SP_VERSION

 JSR TT15b              \ Call TT15b to draw crosshairs of size 20 just to the
                        \ left of the middle of the screen, in the current
                        \ colour (yellow)

ENDIF

 LDA #10                \ Set QQ19+2 to size 10 for the crosshairs size
 STA QQ19+2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

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

