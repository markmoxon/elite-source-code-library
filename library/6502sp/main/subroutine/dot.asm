\ ******************************************************************************
\
\       Name: DOT
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a dash on the compass by sending a #DOdot command to the I/O
\             processor
\
\ ------------------------------------------------------------------------------
\
\ Draw a dash on the compass.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   COMX                The screen pixel x-coordinate of the dash
\
\   COMY                The screen pixel y-coordinate of the dash
\
\   COMC                The colour and thickness of the dash:
\
\                         * #WHITE2 = a double-height dash in white, for when
\                           the object in the compass is in front of us
\
\                         * #GREEN2 = a single-height dash in green, for when
\                           the object in the compass is behind us
\
\ ******************************************************************************

.DOT

 LDA COMY               \ Store the y-coordinate of the dash in byte #0 of the
 STA DOTY1              \ parameter block below

 LDA COMX               \ Store the x-coordinate of the dash in byte #1 of the
 STA DOTX1              \ parameter block below

 LDA COMC               \ Store the dash colour in byte #2 of the parameter
 STA DOTCOL             \ block below

 LDX #LO(DOTpars)       \ Set (Y X) to point to the parameter block below
 LDY #HI(DOTpars)

 LDA #DOdot             \ Send a #DODKS4 command to the I/O processor to draw
 JMP OSWORD             \ the dash on-screen, returning from the subroutine
                        \ using a tail call

.DOTpars

 EQUB 5                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

.DOTX1

 EQUB 0                 \ The x-coordinate of the dash

.DOTY1

 EQUB 0                 \ The y-coordinate of the dash

.DOTCOL

 EQUB 0                 \ The colour of the dash

 RTS                    \ End of the parameter block

