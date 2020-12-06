\ ******************************************************************************
\
\       Name: TITLE
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display a title screen with a rotating ship and prompt
\
\ ------------------------------------------------------------------------------
\
\ Display a title screen, with a rotating ship and a recursive text token at the
\ bottom of the screen.
\
\ Arguments:
\
\   A                   The number of the recursive token to show below the
\                       rotating ship (see variable QQ18 for details of
\                       recursive tokens)
\
\   X                   The type of the ship to show (see variable XX21 for a
\                       list of ship types)
\
\ ******************************************************************************

.TITLE

 PHA                    \ Store the token number on the stack for later

 STX TYPE               \ Store the ship type in location TYPE

 JSR RESET              \ Reset our ship so we can use it for the rotating
                        \ title ship

IF _6502SP_VERSION

 JSR ZEKTRAN            \ Reset the key logger buffer that gets returned from
                        \ the I/O processor

 LDA #32                \ Send a #SETVDU19 32 command to the I/O processor to
 JSR DOVDU19            \ set the mode 1 palette to yellow (colour 1), white
                        \ (colour 2) and cyan (colour 3)

ENDIF

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 1

IF _CASSETTE_VERSION

 DEC QQ11               \ Decrement QQ11 to 0, so from here on we are using a
                        \ space view

ELIF _6502SP_VERSION

 LDA #RED
 JSR DOCOL
 STZ QQ11

ENDIF

 LDA #96                \ Set nosev_z hi = 96 (96 is the value of unity in the
 STA INWK+14            \ rotation vector)

\LSR A                  \ This instruction is commented out in the original
                        \ source. It would halve the value of z_hi to 48, so the
                        \ ship would start off closer to the viewer

 STA INWK+7             \ Set z_hi, the high byte of the ship's z-coordinate,
                        \ to 96, which is the distance at which the rotating
                        \ ship starts out before coming towards us

 LDX #127
 STX INWK+29            \ Set roll counter = 127, so don't dampen the roll
 STX INWK+30            \ Set pitch counter = 127, so don't dampen the pitch

 INX                    \ Set QQ17 to 128 (so bit 7 is set) to switch to
 STX QQ17               \ Sentence Case, with the next letter printing in upper
                        \ case

 LDA TYPE               \ Set up a new ship, using the ship type in TYPE
 JSR NWSHP

IF _CASSETTE_VERSION

 LDY #6                 \ Set the text cursor to column 6
 STY XC

 JSR DELAY              \ Delay for 6 vertical syncs (6/50 = 0.12 seconds)

ELIF _6502SP_VERSION

 LDA #6
 JSR DOXC

ENDIF

 LDA #30                \ Print recursive token 144 ("---- E L I T E ----")
 JSR plf                \ followed by a newline

IF _CASSETTE_VERSION

 LDY #6                 \ Set the text cursor to column 6 again
 STY XC

 INC YC                 \ Move the text cursor down a row

ELIF _6502SP_VERSION

 LDA #10
 JSR TT26
 LDA #6
 JSR DOXC

ENDIF

 LDA PATG               \ If PATG = 0, skip the following two lines, which
 BEQ awe                \ print the author credits (PATG can be toggled by
                        \ pausing the game and pressing "X")

IF _CASSETTE_VERSION

 LDA #254               \ Print recursive token 94, "BY D.BRABEN & I.BELL"
 JSR TT27

ELIF _6502SP_VERSION

 LDA #13
 JSR DETOK

ENDIF

.awe

IF _6502SP_VERSION

 LDA brkd
 BEQ BRBR2
 INC brkd
 LDA #7
 JSR DOXC
 LDA #10
 JSR DOYC
 LDY #0
 JSR OSWRCH
 INY
 LDA (&FD),Y
 BNE P%-6

.BRBR2

ENDIF

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows.
                        \ It also returns with Y = 0

 STY DELTA              \ Set DELTA = 0 (i.e. ship speed = 0)

 STY JSTK               \ Set KSTK = 0 (i.e. keyboard, not joystick)

IF _CASSETTE_VERSION

 PLA                    \ Restore the recursive token number we stored on the
 JSR ex                 \ stack at the start of this subroutine, and print that
                        \ token

 LDA #148               \ Move the text cursor to column 7 and print recursive
 LDX #7                 \ token 148 ("(C) ACORNSOFT 1984")
 STX XC
 JSR ex

ELIF _6502SP_VERSION

 PLA
\JSRex
 JSR DETOK
 LDA #7
 JSR DOXC
 LDA #12
 JSR DETOK
 LDA #12
 STA CNT2
 LDA #5
 STA MCNT

ENDIF

.TLL2

 LDA INWK+7             \ If z_hi (the ship's distance) is 1, jump to TL1 to
 CMP #1                 \ skip the following decrement
 BEQ TL1

 DEC INWK+7             \ Decrement the ship's distance, to bring the ship
                        \ a bit closer to us

.TL1

 JSR MVEIT              \ Move the ship in space according to the orientation
                        \ vectors and the new value in z_hi

IF _CASSETTE_VERSION

 LDA #128               \ Set z_lo = 128 (so the closest the ship gets to us is
 STA INWK+6             \ z_hi = 1, z_lo = 128, or 256 + 128 = 384

 ASL A                  \ Set A = 0

 STA INWK               \ Set x_lo = 0, so ship remains in the screen centre

 STA INWK+3             \ Set y_lo = 0, so ship remains in the screen centre

ELIF _6502SP_VERSION

 LDX #128
 STX INWK+6
 LDA MCNT
 AND #3
 BNE nodesire

 STX NEEDKEY            \ Set NEEDKEY = 128, so calls to LL9 to draw the ship
                        \ also scan for key presses

.nodesire

 STZ INWK
 STZ INWK+3

ENDIF

 JSR LL9                \ Call LL9 to display the ship

IF _CASSETTE_VERSION

 DEC MCNT               \ Decrement the main loop counter

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

ELIF _6502SP_VERSION

 LDA KTRAN+12           \ Fetch the key press state for the joystick 1 fire
                        \ button from the key logger buffer, which contains
                        \ the value of the 6522 System VIA input register IRB
                        \ (SHEILA &40)

ENDIF

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

IF _CASSETTE_VERSION

\TAX                    \ This instruction is commented out in the original
                        \ source

ELIF _6502SP_VERSION

 TAX

ENDIF

 BEQ TL2                \ If the joystick fire button is pressed, jump to BL2

IF _CASSETTE_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press

 BEQ TLL2               \ If no key was pressed, loop back up to move/rotate
                        \ the ship and check again for a key press

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA KTRAN              \ Fetch the internal key number of the current key
                        \ press from the key logger buffer

 BNE TL3                \ If a key is being pressed, jump to TL3

 DEC MCNT
 BNE TLL2

 DEC CNT2
 BNE TLL2

 JMP DEMON

ENDIF

.TL2

 DEC JSTK               \ Joystick fire button was pressed, so set JSTK to &FF
                        \ (it was set to 0 above), to disable keyboard and
                        \ enable joysticks

IF _6502SP_VERSION

.TL3

ENDIF

 RTS                    \ Return from the subroutine

