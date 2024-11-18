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
ELIF _APPLE_VERSION
\   A                   ???
\
\   X                   ???
\
ENDIF
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BULB-2              Set the Y screen address
\
ENDIF
\ ******************************************************************************

.BULB

IF NOT(_APPLE_VERSION)

 STA SC                 \ Store the low byte of the screen address in SC

ELIF _APPLE_VERSION

 STA P                  \ Store the low byte of the screen address in P

ENDIF

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

ELIF _APPLE_VERSION

 LDA #HI(SPBT)          \ ???
 STA P+1
 LDA #22
 STA YC

ELIF _ELITE_A_FLIGHT

 LDA #&7D               \ Set A to the high byte of the screen address, which is
                        \ &7D as the bulbs are both in the character row from
                        \ &7D00 to &7DFF

 STX P+1                \ Set P(2 1) = (Y X)
 STY P+2

ELIF _ELITE_A_6502SP_IO

 LDA #&7D               \ Set A to the high byte of the screen address, which is
                        \ &7D as the bulbs are both in the character row from
                        \ &7D00 to &7DFF

 STA SC+1               \ Set the high byte of SC(1 0) to &7D, so SC now points
                        \ to the screen address of the bulb we want to draw

 STX font               \ Set font(1 0) = (Y X)
 STY font+1

 LDY #7                 \ We now want to draw the bulb by copying the bulb
                        \ character definition from font(1 0) into the screen
                        \ address at SC(1 0), so set a counter in Y to work
                        \ through the eight bytes (one per row) in the bulb

.ECBLBor

 LDA (font),Y           \ Fetch the Y-th row of the bulb character definition
                        \ from font(1 0)

 EOR (SC),Y             \ Draw the row on-screen using EOR logic, so if the bulb
 STA (SC),Y             \ is already on-screen this will remove it, otherwise it
                        \ will light the bulb up

 DEY                    \ Decrement the row counter

 BPL ECBLBor            \ Loop back to ECBLBor until we have drawn all 8 rows of
                        \ the bulb

 RTS                    \ Return from the subroutine

ENDIF

IF NOT(_ELITE_A_6502SP_IO OR _APPLE_VERSION)

 JMP RREN               \ Call RREN to print the character definition pointed to
                        \ by P(2 1) at the screen address pointed to by (A SC),
                        \ returning from the subroutine using a tail call

ELIF _APPLE_VERSION

 JMP letter2            \ ???

ENDIF

