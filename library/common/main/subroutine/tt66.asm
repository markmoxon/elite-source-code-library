\ ******************************************************************************
\
\       Name: TT66
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Clear the screen and set the current view type
\
\ ------------------------------------------------------------------------------
\
\ Clear the top part of the screen, draw a white border, and set the current
\ view type in QQ11 to A.
\
\ Arguments:
\
\   A                   The type of the new current view (see QQ11 for a list of
\                       view types)
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\ Other entry points:
\
\   TT66-2              Call TT66 with A = 1
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #1                 \ Set the view type to 1 when this is called via the
                        \ TT66-2 entry point

ENDIF

.TT66

 STA QQ11               \ Set the current view type in QQ11 to A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Label

                        \ Fall through into TTX66 to clear the screen and draw a
                        \ white border

ELIF _MASTER_VERSION

                        \ Fall through into TTX662 to clear the screen and draw
                        \ a white border

ENDIF

