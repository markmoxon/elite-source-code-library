\ ******************************************************************************
\
\       Name: CATD
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load disc sectors 0 and 1 to &0E00 and &0F00 respectively
\  Deep dive: Swapping between the docked and flight code
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied to &0D7A in part 1 above. It is called by both the main
\ docked code and the main flight code, just before the docked code, flight code
\ or ship blueprint files are loaded.
\
\ ******************************************************************************

.CATD

 DEC CATBLOCK+8         \ Decrement sector number from 1 to 0
 DEC CATBLOCK+2         \ Decrement load address from &0F00 to &0E00

 JSR CATL               \ Call CATL to load disc sector 1 to &0E00

 INC CATBLOCK+8         \ Increment sector number back to 1
 INC CATBLOCK+2         \ Increment load address back to &0F00

.CATL

 LDA #127               \ Call OSWORD with A = 127 and (Y X) = CATBLOCK to
 LDX #LO(CATBLOCK)      \ load disc sector 1 to &0F00
 LDY #HI(CATBLOCK)
 JMP OSWORD

