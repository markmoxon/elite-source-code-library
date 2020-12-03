\ ******************************************************************************
\
IF _CASSETTE_VERSION
\       Name: DET1
ELIF _6502SP_VERSION
\       Name: DODIALS
ENDIF
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Hide the dashboard (for when we die)
\
\ ------------------------------------------------------------------------------
\
\ Set the screen to show the number of text rows given in X. This is used when
\ we are killed, as reducing the number of rows from the usual 31 to 24 has the
\ effect of hiding the dashboard, leaving a monochrome image of ship debris and
\ explosion clouds. Increasing the rows back up to 31 makes the dashboard
\ reappear, as the dashboard's screen memory doesn't get touched by this
\ process.
\
\ Arguments:
\
\   X                   The number of text rows to display on the screen (24
\                       will hide the dashboard, 31 will make it reappear)
\
\ Returns
\
\   A                   A is set to 6
\
\ ******************************************************************************

IF _CASSETTE_VERSION

.DET1

ELIF _6502SP_VERSION

.DODIALS

 TAX

ENDIF

 LDA #6                 \ Set A to 6 so we can update 6845 register R6 below

 SEI                    \ Disable interrupts so we can update the 6845

 STA VIA+&00            \ Set 6845 register R6 to the value in X. Register R6
 STX VIA+&01            \ is the "vertical displayed" register, which sets the
                        \ number of rows shown on the screen

 CLI                    \ Re-enable interrupts

IF _CASSETTE_VERSION

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ENDIF

