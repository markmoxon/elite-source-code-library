\ ******************************************************************************
\
\       Name: DIALS (Part 1 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: speed indicator
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ This routine updates the dashboard. First we draw all the indicators in the
\ right part of the dashboard, from top (speed) to bottom (energy banks), and
\ then we move on to the left part, again drawing from top (forward shield) to
\ bottom (altitude).
\
\ This first section starts us off with the speedometer in the top right.
\
\ ******************************************************************************

.DIALS

 LDY #0                 \ Set Y = 0 to use as an index into the dial tables as
                        \ we work our way through the various indicators

 LDA #210               \ Set K = 210 to use as the pixel x-coordinate of the
 STA K                  \ left end of the indicators in the right half of the
                        \ dashboard, which we draw first

 LDX #RED               \ Set X to the colour we should show for dangerous
                        \ values (i.e. red)

 LDA MCNT               \ A will be non-zero for 8 out of every 16 main loop
 AND #%00001000         \ counts, when bit 4 is set, so this is what we use to
                        \ flash the "danger" colour

 AND FLH                \ A will be zeroed if flashing colours are disabled

 BEQ P%+4               \ If A is zero, skip the next instruction

 LDX #WHITE             \ If we get here then flashing colours are configured
                        \ and it is the right time to flash the danger colour,
                        \ so set X to white

 STX K+2                \ Set K+2 to the colour to use for dangerous values

 LDA DELTA              \ Fetch our ship's speed into A, in the range 0-40

 JSR DIS2               \ Call DIS2 with Y = 0 to draw the speed indicator using
                        \ a range of 0-31, and increment Y to 1 to point to the
                        \ next indicator (the roll indicator)

