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
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\   A                   The y-coordinate of the bulb as a low-byte screen
\                       address offset within screen page &7D (as both bulbs
\                       are on this character row in the dashboard)
\
\   (Y X)               The address of the character definition of the bulb to
\                       be drawn (i.e. ECBT for the E.C.M. bulb, or SPBT for the
\                       space station bulb)
ELIF _ELECTRON_VERSION
\   A                   The low byte of the screen address of the bulb to show
\
\   X                   The low byte of the address of the character definition
\                       of the bulb to be drawn, i.e. #LO(ECBT) for the E.C.M.
\                       bulb, or #LO(SPBT) for the space station bulb
\
\   Y                   The high byte of the screen address of the bulb to show
ENDIF
\
\ ******************************************************************************

.BULB

 STA SC                 \ Store the low byte of the screen address in SC

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 STX P+1                \ Set P(2 1) = (Y X)
 STY P+2

 LDA #&7D               \ Set A to the high byte of the screen address, which is
                        \ &7D as the bulbs are both in the character row from
                        \ &7D00 to &7DFF

ELIF _ELECTRON_VERSION

 STX P+1                \ Set P(2 1) to the address of the character definition
 LDX #HI(ECBT)          \ of the bulb to be drawn (this assumes that ECBT and
 STX P+2                \ SPBT are in the same page and have the same high byte)

 TYA                    \ Set A to Y, the high byte of the screen address we
                        \ want to write to, so now (A SC) points to the specific
                        \ bulb's screen address

ELIF _ELITE_A_VERSION

 LDA #&7D               \ Set A to the high byte of the screen address, which is
                        \ &7D as the bulbs are both in the character row from
                        \ &7D00 to &7DFF

 STX P+1                \ Set P(2 1) = (Y X)
 STY P+2

ENDIF

 JMP RREN               \ Call RREN to print the character definition pointed to
                        \ by P(2 1) at the screen address pointed to by (A SC),
                        \ returning from the subroutine using a tail call

