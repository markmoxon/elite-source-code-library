\ ******************************************************************************
\
\       Name: TITLE
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display a title screen with a rotating ship and prompt
\
\ ------------------------------------------------------------------------------
\
\ Display the title screen, with a rotating ship and a text token at the bottom
\ of the screen.
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Comment
\   A                   The number of the recursive token to show below the
\                       rotating ship (see variable QQ18 for details of
\                       recursive tokens)
ELIF _6502SP_VERSION
\   A                   The number of the extended token to show below the
\                       rotating ship (see variable TKN1 for details of
\                       recursive tokens)
ENDIF
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

IF _6502SP_VERSION \ Tube

 JSR ZEKTRAN            \ Reset the key logger buffer that gets returned from
                        \ the I/O processor

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #32                \ Send a #SETVDU19 32 command to the I/O processor to
 JSR DOVDU19            \ set the mode 1 palette to yellow (colour 1), white
                        \ (colour 2) and cyan (colour 3)

ENDIF

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 1

IF _6502SP_VERSION \ Screen

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is white in the title screen

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Minor

 DEC QQ11               \ Decrement QQ11 to 0, so from here on we are using a
                        \ space view

ELIF _6502SP_VERSION

 STZ QQ11               \ Set QQ11 to 0, so from here on we are using a space
                        \ view

ENDIF

 LDA #96                \ Set nosev_z hi = 96 (96 is the value of unity in the
 STA INWK+14            \ rotation vector)

IF _DISC_DOCKED \ Other: The disc version contains various bits of copy protection code injected into the loader, and the results get checked in the main title sequence to make sure nothing has been changed

 LDA &9F                \ As part of the copy protection, location &9F is set to
 CMP #219               \ 219 in the OSBmod routine in elite-loader3.asm. This
 BEQ tiwe               \ jumps to tiwe if the value is unchanged, otherwise it
                        \ crashes the game with the following (as presumably
                        \ the game code has been tampered with)

 LDA #&10               \ Modify the STA DELTA instruction in RES2 to &10 &FE,
 STA modify+2           \ which is a BPL P%-2 instruction, to create an infinite
 LDA #&FE               \ loop and hang the game
 STA modify+3

.tiwe

ENDIF

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

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 LDY #6                 \ Move the text cursor to column 6
 STY XC

ELIF _6502SP_VERSION

 LDA #6                 \ Move the text cursor to column 6
 JSR DOXC

ENDIF

IF _CASSETTE_VERSION \ Platform

 JSR DELAY              \ Delay for 6 vertical syncs (6/50 = 0.12 seconds)

ENDIF

 LDA #30                \ Print recursive token 144 ("---- E L I T E ----")
 JSR plf                \ followed by a newline

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 LDY #6                 \ Move the text cursor to column 6 again
 STY XC

 INC YC                 \ Move the text cursor down a row

ELIF _6502SP_VERSION

 LDA #10                \ Print a line feed to move the text cursor down a line
 JSR TT26

 LDA #6                 \ Move the text cursor to column 6 again
 JSR DOXC

ENDIF

 LDA PATG               \ If PATG = 0, skip the following two lines, which
 BEQ awe                \ print the author credits (PATG can be toggled by
                        \ pausing the game and pressing "X")

IF _CASSETTE_VERSION \ Minor

 LDA #254               \ Print recursive token 94 ("BY D.BRABEN & I.BELL")
 JSR TT27

ELIF _6502SP_VERSION OR _DISC_DOCKED

 LDA #13                \ Print extended token 13 ("BY D.BRABEN & I.BELL")
 JSR DETOK

ENDIF

.awe

IF _6502SP_VERSION OR _DISC_DOCKED \ Platform

 LDA brkd               \ If brkd = 0, jump to BRBR2 to skip the following, as
 BEQ BRBR2              \ we do not have a system error message to display

 INC brkd               \ Increment the brkd counter

ENDIF

IF _DISC_DOCKED \ Tube

 LDA #7                 \ Move the text cursor to column 7
 STA XC

 LDA #10                \ Move the text cursor to row 10
 STA YC

ELIF _6502SP_VERSION

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

 LDA #10                \ Move the text cursor to row 10
 JSR DOYC

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED \ Platform

                        \ The following loop prints out the null-terminated
                        \ message pointed to by (&FD &FE), which is the MOS
                        \ error message pointer - so this prints the error
                        \ message on the next line

 LDY #0                 \ Set Y = 0 to act as a character counter

 JSR OSWRCH             \ Print the character in A (which contains a line feed
                        \ on the first loop iteration), and then any non-zero
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE P%-6               \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print it, and keep looping until
                        \ we fetch a zero (which marks the end of the message)

.BRBR2

ENDIF

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows.
                        \ It also returns with Y = 0

 STY DELTA              \ Set DELTA = 0 (i.e. ship speed = 0)

 STY JSTK               \ Set KSTK = 0 (i.e. keyboard, not joystick)

IF _CASSETTE_VERSION \ Minor

 PLA                    \ Restore the recursive token number we stored on the
 JSR ex                 \ stack at the start of this subroutine, and print that
                        \ token

 LDA #148               \ Set A to recursive token 148

 LDX #7                 \ Move the text cursor to column 7
 STX XC

 JSR ex                 \ Print recursive token 148 ("(C) ACORNSOFT 1984")

ELIF _DISC_DOCKED

 PLA                    \ Restore the recursive token number we stored on the
                        \ stack at the start of this subroutine

\JSR ex                 \ This instruction is commented out in the original
                        \ source (it would print the recursive token in A)

 JSR DETOK              \ Print the extended token in A

 LDA #12                \ Set A to extended token 12

 LDX #7                 \ Move the text cursor to column 7
 STX XC

 JSR DETOK              \ Print extended token 12 ("({single cap}C) ACORNSOFT
                        \ 1984")

ELIF _6502SP_VERSION

 PLA                    \ Restore the recursive token number we stored on the
                        \ stack at the start of this subroutine

\JSR ex                 \ This instruction is commented out in the original
                        \ source (it would print the recursive token in A)

 JSR DETOK              \ Print the extended token in A

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

 LDA #12                \ Print extended token 12 ("({single cap}C) ACORNSOFT
 JSR DETOK              \ 1984")

ENDIF

IF _6502SP_VERSION \ Advanced: Group A: The 6502SP version adds two loop counters to the title screen so we can start the demo after a certain period on the title screen

 LDA #12                \ Set CNT2 = 12 as the outer loop counter for the loop
 STA CNT2               \ starting at TLL2

 LDA #5                 \ Set the main loop counter in MCNT to 5, to act as the
 STA MCNT               \ inner loop counter for the loop starting at TLL2

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

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Minor

 LDA #128               \ Set z_lo = 128 (so the closest the ship gets to us is
 STA INWK+6             \ z_hi = 1, z_lo = 128, or 256 + 128 = 384

ELIF _6502SP_VERSION

 LDX #128               \ Set z_lo = 128 (so the closest the ship gets to us is
 STX INWK+6             \ z_hi = 1, z_lo = 128, or 256 + 128 = 384

ENDIF

IF _6502SP_VERSION \ Advanced: The 6502SP version only scans for keypresses every four iterations on the title screen (as opposed to every iteration in the other versions), so you have to hold down Y/N or Space for longer to load a commander or start the game

 LDA MCNT               \ This value will be zero on one out of every four
 AND #3                 \ iterations, so for the other three, skip to nodesire
 BNE nodesire           \ so we only scan for key presses once every four loops

 STX NEEDKEY            \ Set NEEDKEY = 128, so the call to LL9 below draw the
                        \ ship and scans for key presses (LL9 resets NEEDKEY to
                        \ 0 so we have to reset NEEDKEY every four iterations
                        \ round the inner loop)

.nodesire

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Minor

 ASL A                  \ Set A = 0

 STA INWK               \ Set x_lo = 0, so the ship remains in the screen centre

 STA INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

ELIF _6502SP_VERSION

 STZ INWK               \ Set x_lo = 0, so the ship remains in the screen centre

 STZ INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

ENDIF

 JSR LL9                \ Call LL9 to display the ship

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Platform

 DEC MCNT               \ Decrement the main loop counter

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

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

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Minor

\TAX                    \ This instruction is commented out in the original
                        \ source; it would have no effect, as the comparison
                        \ flags are already set by the AND, and the value of X
                        \ is not used anywhere

ELIF _6502SP_VERSION

 TAX                    \ Copy the joystick fire button state to X, though this
                        \ instruction has no effect, as the comparison flags are
                        \ already set by the AND and the value of X is not used
                        \ anywhere

ENDIF

 BEQ TL2                \ If the joystick fire button is pressed, jump to TL2

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 JSR RDKEY              \ Scan the keyboard for a key press

 BEQ TLL2               \ If no key was pressed, loop back up to move/rotate
                        \ the ship and check again for a key press

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA KTRAN              \ Fetch the internal key number of the current key
                        \ press from the key logger buffer

 BNE TL3                \ If a key is being pressed, jump to TL3

ENDIF

IF _6502SP_VERSION \ Advanced: See group A

 DEC MCNT               \ Decrement the inner loop counter

 BNE TLL2               \ Loop back to keep the ship rotating, until the inner
                        \ loop counter is zero

 DEC CNT2               \ Decrement the outer loop counter in CNT2

 BNE TLL2               \ Loop back to keep the ship rotating, until the outer
                        \ loop counter is zero

 JMP DEMON              \ Once we have iterated through CNT2 iterations of MCNT,
                        \ jump to DEMON to start the demo

ENDIF

.TL2

 DEC JSTK               \ Joystick fire button was pressed, so set JSTK to &FF
                        \ (it was set to 0 above), to disable keyboard and
                        \ enable joysticks

IF _6502SP_VERSION \ Label

.TL3

ENDIF

 RTS                    \ Return from the subroutine

