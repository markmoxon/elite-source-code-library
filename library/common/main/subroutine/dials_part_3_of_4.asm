\ ******************************************************************************
\
\       Name: DIALS (Part 3 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: four energy banks
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ This and the next section only run once every four iterations of the main
\ loop, so while the speed, pitch and roll indicators update every iteration,
\ the other indicators update less often.
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_FLIGHT

 LDA MCNT               \ Fetch the main loop counter and calculate MCNT mod 4,
 AND #3                 \ jumping to rT9 if it is non-zero. rT9 contains an RTS,
 BNE rT9                \ so the following code only runs every 4 iterations of
                        \ the main loop, otherwise we return from the subroutine

ELIF _DISC_DOCKED

 LDA MCNT               \ Fetch the main loop counter and calculate MCNT mod 4,
 AND #3                 \ jumping to R5-1 if it is non-zero. R5-1 contains an
 BNE R5-1               \ RTS, so the following code only runs every 4
                        \ iterations of the main loop, otherwise we return from
                        \ the subroutine

ENDIF

 LDY #0                 \ Set Y = 0, for use in various places below

 JSR PZW                \ Call PZW to set A to the colour for dangerous values
                        \ and X to the colour for safe values

 STX K                  \ Set K (the colour we should show for high values) to X
                        \ (the colour to use for safe values)

 STA K+1                \ Set K+1 (the colour we should show for low values) to
                        \ A (the colour to use for dangerous values)

                        \ The above sets the following indicators to show red
                        \ for low values and yellow/white for high values, which
                        \ we use not only for the energy banks, but also for the
                        \ shield levels and current fuel

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDX #3                 \ Set up a counter in X so we can zero the four bytes at
                        \ XX12, so we can then calculate each of the four energy
                        \ banks' values before drawing them later

ELIF _6502SP_VERSION

 LDX #3                 \ Set up a counter in X so we can zero the four bytes at
                        \ XX15, so we can then calculate each of the four energy
                        \ banks' values before drawing them later

ENDIF

 STX T1                 \ Set T1 to 3, the threshold at which we change the
                        \ indicator's colour

.DLL23

IF _CASSETTE_VERSION OR _DISC_VERSION

 STY XX12,X             \ Set the X-th byte of XX12 to 0

ELIF _6502SP_VERSION

 STY XX15,X             \ Set the X-th byte of XX15 to 0

ENDIF

 DEX                    \ Decrement the counter

 BPL DLL23              \ Loop back for the next byte until the four bytes at
                        \ XX12 are all zeroed

 LDX #3                 \ Set up a counter in X to loop through the 4 energy
                        \ bank indicators, so we can calculate each of the four
                        \ energy banks' values and store them in XX12

 LDA ENERGY             \ Set A = Q = ENERGY / 4, so they are both now in the
 LSR A                  \ range 0-63 (so that's a maximum of 16 in each of the
 LSR A                  \ banks, and a maximum of 15 in the top bank)

 STA Q                  \ Set Q to A, so we can use Q to hold the remaining
                        \ energy as we work our way through each bank, from the
                        \ full ones at the bottom to the empty ones at the top

.DLL24

 SEC                    \ Set A = A - 16 to reduce the energy count by a full
 SBC #16                \ bank

 BCC DLL26              \ If the C flag is clear then A < 16, so this bank is
                        \ not full to the brim, and is therefore the last one
                        \ with any energy in it, so jump to DLL26

 STA Q                  \ This bank is full, so update Q with the energy of the
                        \ remaining banks

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA #16                \ Store this bank's level in XX12 as 16, as it is full,
 STA XX12,X             \ with XX12+3 for the bottom bank and XX12+0 for the top

ELIF _6502SP_VERSION

 LDA #16                \ Store this bank's level in XX15 as 16, as it is full,
 STA XX15,X             \ with XX15+3 for the bottom bank and XX15+0 for the top

ENDIF

 LDA Q                  \ Set A to the remaining energy level again

 DEX                    \ Decrement X to point to the next bank, i.e. the one
                        \ above the bank we just processed

 BPL DLL24              \ Loop back to DLL24 until we have either processed all
                        \ four banks, or jumped out early to DLL26 if the top
                        \ banks have no charge

 BMI DLL9               \ Jump to DLL9 as we have processed all four banks (this
                        \ BMI is effectively a JMP as A will never be positive)

.DLL26

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA Q                  \ If we get here then the bank we just checked is not
 STA XX12,X             \ fully charged, so store its value in XX12 (using Q,
                        \ which contains the energy of the remaining banks -
                        \ i.e. this one)

ELIF _6502SP_VERSION

 LDA Q                  \ If we get here then the bank we just checked is not
 STA XX15,X             \ fully charged, so store its value in XX15 (using Q,
                        \ which contains the energy of the remaining banks -
                        \ i.e. this one)

ENDIF

                        \ Now that we have the four energy bank values in XX12,
                        \ we can draw them, starting with the top bank in XX12
                        \ and looping down to the bottom bank in XX12+3, using Y
                        \ as a loop counter, which was set to 0 above

.DLL9

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA XX12,Y             \ Fetch the value of the Y-th indicator, starting from
                        \ the top

ELIF _6502SP_VERSION

 LDA XX15,Y             \ Fetch the value of the Y-th indicator, starting from
                        \ the top

ENDIF

 STY P                  \ Store the indicator number in P for retrieval later

 JSR DIL                \ Draw the energy bank using a range of 0-15, and
                        \ increment SC to point to the next indicator (the
                        \ next energy bank down)

 LDY P                  \ Restore the indicator number into Y

 INY                    \ Increment the indicator number

 CPY #4                 \ Check to see if we have drawn the last energy bank

 BNE DLL9               \ Loop back to DLL9 if we have more banks to draw,
                        \ otherwise we are done

