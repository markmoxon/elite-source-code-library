\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\       Name: hy6
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\       Name: dockEd
ENDIF
\       Type: Subroutine
\   Category: Flight
\    Summary: Print a message to say there is no hyperspacing allowed inside the
\             station
\
\ ------------------------------------------------------------------------------
\
\ Print "Docked" at the bottom of the screen to indicate we can't hyperspace
\ when docked.
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

.hy6

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

.dockEd

ENDIF

IF NOT(_NES_VERSION OR _APPLE_VERSION)

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

ELIF _APPLE_VERSION

 JSR CLYNS              \ Clear a space near the bottom of the screen (one
                        \ character row in the space view, two character rows in
                        \ the text views), and move the text cursor to the first
                        \ cleared row

ELIF _NES_VERSION

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 LDA #15                \ Move the text cursor to column 15 (the middle of the
 STA XC                 \ screen), setting A to 15 at the same time for the
                        \ following call to TT27

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #15                \ Move the text cursor to column 15
 JSR DOXC

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is magenta in the trade view
                        \ or red in the chart view

ELIF _MASTER_VERSION

 LDA #RED               \ Switch to colour 2, which is magenta in the trade view
 STA COL                \ or red in the chart view

ELIF _C64_VERSION OR _APPLE_VERSION

\LDA #RED               \ These instructions are commented out in the original
\JSR DOCOL              \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 JMP TT27               \ Print recursive token 129 ("{sentence case}DOCKED")
                        \ and return from the subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JMP DETOK              \ the subroutine using a tail call

ELIF _NES_VERSION

 LDA #205               \ Print extended token 205 ("DOCKED") and return from
 JMP DETOK_b2           \ the subroutine using a tail call

ENDIF