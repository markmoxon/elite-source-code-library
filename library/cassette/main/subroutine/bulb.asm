\ ******************************************************************************
\
\       Name: BULB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw an indicator bulb on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The y-coordinate of the bulb as a low-byte screen
\                       address offset within screen page &7D (as both bulbs
\                       are on this character row in the dashboard)
\
\   (Y X)               The address of the character definition of the bulb to
\                       be drawn (i.e. ECBT for the E.C.M. bulb, or SPBT for the
\                       space station bulb)
\
\ ******************************************************************************

.BULB

 STA SC                 \ Store the low byte of the screen address in SC

 STX P+1                \ Set P(2 1) = (Y X)
 STY P+2

 LDA #&7D               \ Set A to the high byte of the screen address, which is
                        \ &7D as the bulbs are both in the character row from
                        \ &7D00 to &7DFF

 JMP RREN               \ Call RREN to print the character definition pointed to
                        \ by P(2 1) at the screen address pointed to by (A SC),
                        \ returning from the subroutine using a tail call

