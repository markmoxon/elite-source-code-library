\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
\       Name: DET1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Show or hide the dashboard (for when we die)
ELIF _6502SP_VERSION
\       Name: DODIALS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Implement the #DODIALS <rows> command (show or hide the dashboard)
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ This routine sets the screen to show the number of text rows given in X.
ELIF _ELITE_A_6502SP_IO
\ This routine is run when the parasite sends a write_crtc command. It updates
\ the number of text rows shown on the screen, which has the effect of hiding or
\ showing the dashboard.
ENDIF
\
\ It is used when we are killed, as reducing the number of rows from the usual
\ 31 to 24 has the effect of hiding the dashboard, leaving a monochrome image
\ of ship debris and explosion clouds. Increasing the rows back up to 31 makes
\ the dashboard reappear, as the dashboard's screen memory doesn't get touched
\ by this process.
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of text rows to display on the screen (24
\                       will hide the dashboard, 31 will make it reappear)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 6
\
ELIF _6502SP_VERSION
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of text rows to display on the screen (24
\                       will hide the dashboard, 31 will make it reappear)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 6
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Label

.DET1

ELIF _6502SP_VERSION

.DODIALS

ENDIF

IF _6502SP_VERSION \ Platform

 TAX                    \ Copy the number of rows to display into X

ENDIF

IF NOT(_ELITE_A_6502SP_IO)

 LDA #6                 \ Set A to 6 so we can update 6845 register R6 below

ELIF _ELITE_A_6502SP_IO

 JSR tube_get           \ Get the number of rows from the parasite into A

 LDX #6                 \ Set X to 6 so we can update 6845 register R6 below

ENDIF

 SEI                    \ Disable interrupts so we can update the 6845

IF NOT(_ELITE_A_6502SP_IO)

 STA VIA+&00            \ Set 6845 register R6 to the value in X. Register R6
 STX VIA+&01            \ is the "vertical displayed" register, which sets the
                        \ number of rows shown on the screen

ELIF _ELITE_A_6502SP_IO

 STX VIA+&00            \ Set 6845 register R6 to the value in A. Register R6
 STA VIA+&01            \ is the "vertical displayed" register, which sets the
                        \ number of rows shown on the screen

ENDIF

 CLI                    \ Re-enable interrupts

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

ENDIF

