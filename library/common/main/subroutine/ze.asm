\ ******************************************************************************
\
\       Name: Ze
\       Type: Subroutine
\   Category: Universe
\    Summary: Initialise the INWK workspace to a hostile ship
\
\ ------------------------------------------------------------------------------
\
\ Specifically, this routine does the following:
\
\   * Reset the INWK ship workspace
\
\   * Set the ship to a fair distance away in all axes, in front of us but
\     randomly up or down, left or right
\
\   * Give the ship a 4% chance of having E.C.M.
\
\   * Set the ship to hostile, with AI enabled
\
\ This routine also sets A, X, T1 and the C flag to random values.
\
\ ******************************************************************************

.Ze

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

 JSR DORND              \ Set A and X to random numbers

 STA T1                 \ Store A in T1

 AND #%10000000         \ Extract the sign of A and store in x_sign
 STA INWK+2

 TXA                    \ Extract the sign of X and store in y_sign
 AND #%10000000
 STA INWK+5

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA #32                \ Set x_hi = y_hi = z_hi = 32, a fair distance away
 STA INWK+1
 STA INWK+4
 STA INWK+7

ELIF _6502SP_VERSION

 LDA #25                \ Set x_hi = y_hi = z_hi = 25, a fair distance away
 STA INWK+1
 STA INWK+4
 STA INWK+7

ENDIF

 TXA                    \ Set the C flag if X >= 245 (4% chance)
 CMP #245

 ROL A                  \ Set bit 0 of A to the C flag (i.e. there's a 4%
                        \ chance of this ship having E.C.M.)

 ORA #%11000000         \ Set bits 6 and 7 of A, so the ship is hostile (bit 6
                        \ and has AI (bit 7)

 STA INWK+32            \ Store A in the AI flag of this ship

                        \ Fall through into DORND2 to set A, X and the C flag
                        \ randomly

