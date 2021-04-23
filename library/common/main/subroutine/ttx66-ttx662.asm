\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Comment
\       Name: TTX66
ELIF _MASTER_VERSION
\       Name: TTX662
ENDIF
\       Type: Subroutine
\   Category: Utility routines
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Clear the top part of the screen and draw a white border
ELIF _6502SP_VERSION
\    Summary: Send control code 11 to the I/O processor to clear the top part
\             of the screen and draw a white border
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Clear the top part of the screen (the space view) and draw a white border
\ along the top and sides.
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Comment
\ Other entry points:
\
\   BOX                 Just draw the border and (if this is a space view) the
\                       view name. This can be used to remove the border and
\                       view name, as it is drawn using EOR logic
\
ENDIF
IF _ELECTRON_VERSION \ Comment
\   BORDER              Just draw the border
\
ENDIF
IF _DISC_DOCKED \ Comment
\ Other entry points:
\
\   BOL1-1              Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Label

.TTX66

ELIF _MASTER_VERSION

.TTX662

 JSR TTX66              \ Call TTX66 to clear the top part of the screen and
                        \ draw a white border

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION \ Enhanced: Group A: The default case for enhanced text tokens is Sentence Case

 JSR MT2                \ Switch to Sentence Case when printing extended tokens

ENDIF

IF _6502SP_VERSION \ Tube

 JSR PBZE               \ Reset the pixel buffer size in PBUP

 JSR HBZE               \ Reset the horizontal line buffer size in HBUP

 STZ LBUP               \ Reset the line buffer size at LBUP

 STZ LSP                \ Reset the ball line heap pointer at LSP

ELIF _MASTER_VERSION

 LDA #0                 \ Reset the ball line heap pointer at LSP
 STA LSP

ENDIF

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

IF _DISC_DOCKED OR _6502SP_VERSION OR _MASTER_VERSION \ Enhanced: See group A

 STA DTW2               \ Set bit 7 of DTW2 to indicate we are not currently
                        \ printing a word

ENDIF

IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 JSR FLFLLS             \ Call FLFLLS to reset the LSO block

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is yellow

ENDIF

IF _CASSETTE_VERSION \ Platform

 ASL A                  \ Set LASCT to 0, as 128 << 1 = %10000000 << 1 = 0. This
 STA LASCT              \ stops any laser pulsing. This instruction is STA LAS2
                        \ in the text source file ELITEC.TXT

ELIF _ELECTRON_VERSION

 ASL A                  \ Set LAS2 to 0, as 128 << 1 = %10000000 << 1 = 0. This
 STA LAS2               \ stops any laser pulsing

ELIF _DISC_DOCKED

 ASL A                  \ Set LASCT to 0, as 128 << 1 = %10000000 << 1 = 0. This
 STA LASCT              \ stops any laser pulsing

ELIF _DISC_FLIGHT

 STA LAS2               \ Set LAS2 = 0 to stop any laser pulsing (the call to
                        \ FLFLLS sets A = 0)

ELIF _6502SP_VERSION

 STZ LAS2               \ Set LAS2 = 0 to stop any laser pulsing

ELIF _MASTER_VERSION

 LDA #0                 \ Set LAS2 = 0 to stop any laser pulsing
 STA LAS2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Minor

 STA DLY                \ Set the delay in DLY to 0, to indicate that we are
                        \ no longer showing an in-flight message, so any new
                        \ in-flight messages will be shown instantly

 STA de                 \ Clear de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't

ELIF _6502SP_VERSION

 STZ DLY                \ Set the delay in DLY to 0, to indicate that we are
                        \ no longer showing an in-flight message, so any new
                        \ in-flight messages will be shown instantly

 STZ de                 \ Clear de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 LDX #&60               \ Set X to the screen memory page for the top row of the
                        \ screen (as screen memory starts at &6000)

.BOL1

 JSR ZES1               \ Call ZES1  to zero-fill the page in X, which clears
                        \ that character row on the screen

 INX                    \ Increment X to point to the next page, i.e. the next
                        \ character row

 CPX #&78               \ Loop back to BOL1 until we have cleared page &7700,
 BNE BOL1               \ the last character row in the space view part of the
                        \ screen (the space view)

ELIF _ELECTRON_VERSION

 LDX #&58               \ Call LYN with X = &58 to clear the screen from page
 JSR LYN                \ &58 to page &75, which clears the whole screen (as
                        \ screen memory starts at &5800)

ELIF _6502SP_VERSION

 LDA #11                \ Send control code 11 to OSWRCH, to instruct the I/O
 JSR OSWRCH             \ processor to clear the top part of the screen

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Label

 LDX QQ22+1             \ Fetch into X the number that's shown on-screen during
                        \ the hyperspace countdown

 BEQ BOX                \ If the counter is zero then we are not counting down
                        \ to hyperspace, so jump to BOX to skip the next
                        \ instruction

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1),
                        \ i.e. print the hyperspace countdown in the top-left
                        \ corner

.BOX

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX QQ22+1             \ Fetch into X the number that's shown on-screen during
                        \ the hyperspace countdown

 BEQ OLDBOX             \ If the counter is zero then we are not counting down
                        \ to hyperspace, so jump to OLDBOX to skip the next
                        \ instruction

 JSR ee3                \ Print the 8-bit number in X at text location (0, 1),
                        \ i.e. print the hyperspace countdown in the top-left
                        \ corner

.OLDBOX

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Tube

 LDY #1                 \ Move the text cursor to row 1
 STY YC

ELIF _6502SP_VERSION

 LDA #1                 \ Move the text cursor to column 1
 JSR DOYC

ENDIF

 LDA QQ11               \ If this is not a space view, jump to tt66 to skip
 BNE tt66               \ displaying the view name

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Tube

 LDY #11                \ Move the text cursor to row 11
 STY XC

ELIF _6502SP_VERSION

 LDA #11                \ Move the text cursor to row 11
 JSR DOXC

ELIF _MASTER_VERSION

 LDA #11                \ Move the text cursor to row 11
 STA XC

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is cyan in the space view

ELIF _MASTER_VERSION

 LDA #CYAN              \ Switch to colour 3, which is cyan in the space view
 STA COL

ENDIF

 LDA VIEW               \ Load the current view into A:
                        \
                        \   0 = front
                        \   1 = rear
                        \   2 = left
                        \   3 = right

 ORA #&60               \ OR with &60 so we get a value of &60 to &63 (96 to 99)

 JSR TT27               \ Print recursive token 96 to 99, which will be in the
                        \ range "FRONT" to "RIGHT"

 JSR TT162              \ Print a space

 LDA #175               \ Print recursive token 15 ("VIEW ")
 JSR TT27

.tt66

IF _6502SP_VERSION \ Platform

 LDA #1                 \ Move the text cursor to column 1, row 1
 JSR DOXC
 JSR DOYC

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

 RTS                    \ Return from the subroutine

.BOX

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is yellow

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Tube

 LDX #0                 \ Set (X1, Y1) to (0, 0)
 STX X1
 STX Y1

 STX QQ17               \ Set QQ17 = 0 to switch to ALL CAPS

ELIF _ELECTRON_VERSION

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

.BORDER

 LDX #0                 \ Set (X1, Y1) to (0, 0)
 STX X1
 STX Y1

ELIF _6502SP_VERSION

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

 STX X1                 \ Set (X1, Y1) to (0, 0)
 STX Y1

 STX Y2                 \ Set Y2 = 0

ELIF _MASTER_VERSION

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Tube

 DEX                    \ Set X2 = 255
 STX X2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Tube

 JSR HLOIN              \ Draw a horizontal line from (X1, Y1) to (X2, Y1), so
                        \ that's (0, 0) to (255, 0), along the very top of the
                        \ screen

ELIF _6502SP_VERSION

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2), so that's
                        \ (0, 0) to (255, 0), along the very top of the screen

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 LDA #2                 \ Set X1 = X2 = 2
 STA X1
 STA X2

 JSR BOS2               \ Call BOS2 below, which will call BOS1 twice, and then
                        \ fall through into BOS2 again, so we effectively do
                        \ BOS1 four times, decrementing X1 and X2 each time
                        \ before calling LOIN, so this whole loop-within-a-loop
                        \ mind-bender ends up drawing these four lines:
                        \
                        \   (1, 0)   to (1, 191)
                        \   (0, 0)   to (0, 191)
                        \   (255, 0) to (255, 191)
                        \   (254, 0) to (254, 191)
                        \
                        \ So that's a 2-pixel wide vertical border along the
                        \ left edge of the upper part of the screen, and a
                        \ 2-pixel wide vertical border along the right edge

.BOS2

 JSR BOS1               \ Call BOS1 below and then fall through into it, which
                        \ ends up running BOS1 twice. This is all part of the
                        \ loop-the-loop border-drawing mind-bender explained
                        \ above

.BOS1

 LDA #0                 \ Set Y1 = 0
 STA Y1

 LDA #2*Y-1             \ Set Y2 = 2 * #Y - 1. The constant #Y is 96, the
 STA Y2                 \ y-coordinate of the mid-point of the space view, so
                        \ this sets Y2 to 191, the y-coordinate of the bottom
                        \ pixel row of the space view

 DEC X1                 \ Decrement X1 and X2
 DEC X2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Platform

 JMP LOIN               \ Draw a line from (X1, Y1) to (X2, Y2), and return from
                        \ the subroutine using a tail call

ELIF _6502SP_VERSION

 JMP LL30               \ Draw a line from (X1, Y1) to (X2, Y2), and return from
                        \ the subroutine using a tail call

ELIF _MASTER_VERSION

 RTS                    \ Return from the subroutine

ENDIF

