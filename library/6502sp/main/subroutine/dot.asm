\ ******************************************************************************
\
\       Name: DOT
\       Type: Subroutine
\   Category: Text
\    Summary: Draw a dot on the compass by sending a #DOdot command to the I/O
\             processor
\
\ ------------------------------------------------------------------------------
\
\ Draw a dot on the compass.
\
\ Arguments:
\
\   COMX                The screen pixel x-coordinate of the dot
\
\   COMY                The screen pixel y-coordinate of the dot
\
\   COMC                The colour and thickness of the dot:
\
\                         * &F0 = a double-height dot in white, for when the
\                           object in the compass is in front of us
\
\                         * &FF = a single-height dot in green, for when the
\                           object in the compass is behind us
\
\ ******************************************************************************

.DOT

 LDA COMY               \ Store the y-coordinate of the dot in byte #0 of the
 STA DOTY1              \ parameter block below

 LDA COMX               \ Store the x-coordinate of the dot in byte #1 of the
 STA DOTX1              \ parameter block below

 LDA COMC               \ Store the dot colour in byte #2 of the parameter block
 STA DOTCOL             \ below

 LDX #LO(DOTpars)       \ Set (Y X) to point to the parameter block below
 LDY #HI(DOTpars)

 LDA #DOdot             \ Send a #DODKS4 command to the I/O processor to draw
 JMP OSWORD             \ the dot on-screen, returning from the subroutine using
                        \ a tail call

.DOTpars

 EQUB 5                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

.DOTX1

 EQUB 0                 \ The x-coordinate of the dot

.DOTY1

 EQUB 0                 \ The y-coordinate of the dot

.DOTCOL

 EQUB 0                 \ The colour of the dot

 RTS                    \ End of the parameter block

