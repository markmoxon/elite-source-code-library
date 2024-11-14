\ ******************************************************************************
\
\       Name: TITLE
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display a title screen with a rotating ship and prompt
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ Display the title screen, with a rotating ship and a text token at the bottom
\ of the screen.
ELIF _NES_VERSION
\ Display the title screen, with a selection of rotating ships.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\   A                   The number of the recursive token to show below the
\                       rotating ship (see variable QQ18 for details of
\                       recursive tokens)
\
ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION
\   A                   The number of the extended token to show below the
\                       rotating ship (see variable TKN1 for details of
\                       recursive tokens)
\
ENDIF
\   X                   The type of the ship to show (see variable XX21 for a
\                       list of ship types)
\
IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment
\   Y                   The distance to show the ship rotating, once it has
\                       finished moving towards us
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the ASCII code
\                       of the key pressed
\
ELIF _NES_VERSION
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              If the A button, Start or Select was being pressed but
\                       has now been released, on either one of the controllers,
\                       then the C flag is set, otherwise it is clear
\
ENDIF
\ ******************************************************************************

.TITLE

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Master: Group A: In the Master version, the Cobra Mk III shown on the first title page is further away than in the other versions, which is implemented by a new variable that contains the distance that the ship should be shown at

 STY distaway           \ Store the ship distance in distaway

ENDIF

IF NOT(_NES_VERSION)

 PHA                    \ Store the token number on the stack for later

ENDIF

 STX TYPE               \ Store the ship type in location TYPE

IF _C64_VERSION

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #&FF               \ ???
 STA MULIE

ENDIF

ELIF _APPLE_VERSION

 LDA #&FF               \ ???
 STA MULIE

ENDIF

 JSR RESET              \ Reset our ship so we can use it for the rotating
                        \ title ship

IF _C64_VERSION

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #0                 \ ???
 STA MULIE

ENDIF

ELIF _APPLE_VERSION

 LDA #0                 \ ???
 STA MULIE

ENDIF

IF _6502SP_VERSION \ Tube

 JSR ZEKTRAN            \ Reset the key logger buffer that gets returned from
                        \ the I/O processor

ELIF _MASTER_VERSION

 JSR ZEKTRAN            \ Call ZEKTRAN to clear the key logger

 JSR ZINF               \ Call ZINF to reset the INWK ship workspace

ELIF _NES_VERSION

 JSR U%                 \ Call U% to clear the key logger

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ELIF _C64_VERSION OR _APPLE_VERSION

 JSR ZEKTRAN            \ Call ZEKTRAN to clear the key logger

ENDIF

IF _6502SP_VERSION \ Comment

 LDA #32                \ Send a #SETVDU19 32 command to the I/O processor to
 JSR DOVDU19            \ set the mode 1 palette to yellow (colour 1), white
                        \ (colour 2) and cyan (colour 3)

ELIF _MASTER_VERSION OR _C64_VERSION

 LDA #32                \ Set the mode 1 palette to yellow (colour 1), white
 JSR DOVDU19            \ (colour 2) and cyan (colour 3)

ELIF _APPLE_VERSION

\LDA #32                \ These instructions are commented out in the original
\JSR DOVDU19            \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform: The Master version has a unique view type for the title screen (13)

 LDA #1                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 1

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #13                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 13 (rotating
                        \ ship view)

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is white in the title screen

ELIF _MASTER_VERSION

 LDA #RED               \ Switch to colour 2, which is white in the title screen
 STA COL

ELIF _C64_VERSION OR _APPLE_VERSION

\LDA #RED               \ These instructions are commented out in the original
\JSR DOCOL              \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Minor

 DEC QQ11               \ Decrement QQ11 to 0, so from here on we are using a
                        \ space view

ELIF _6502SP_VERSION

 STZ QQ11               \ Set QQ11 to 0, so from here on we are using a space
                        \ view

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #0                 \ Set QQ11 to 0, so from here on we are using a space
 STA QQ11               \ view

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

IF _MASTER_VERSION \ Master: See group A

 LDA #96                \ Set A = 96 as the distance that the ship starts at

ELIF _ELITE_A_VERSION

 LDA #219               \ Set A = 219 as the distance that the ship starts at

ELIF _NES_VERSION

 LDA #55                \ Set A = 55 as the distance that the ship starts at

ELIF _C64_VERSION OR _APPLE_VERSION

 LDA #96                \ Set A = 96 as the distance that the ship starts at

ENDIF

IF _CASSETTE_VERSION \ Comment

\LSR A                  \ This instruction is commented out in the original
                        \ source. It would halve the value of z_hi to 48, so the
                        \ ship would start off closer to the viewer

ENDIF

 STA INWK+7             \ Set z_hi, the high byte of the ship's z-coordinate,
                        \ to 96, which is the distance at which the rotating
                        \ ship starts out before coming towards us

 LDX #127               \ Set roll counter = 127, so don't dampen the roll and
 STX INWK+29            \ make the roll direction clockwise

 STX INWK+30            \ Set pitch counter = 127, so don't dampen the pitch and
                        \ set the pitch direction to dive

IF NOT(_ELITE_A_DOCKED)

 INX                    \ Set QQ17 to 128 (so bit 7 is set) to switch to
 STX QQ17               \ Sentence Case, with the next letter printing in upper
                        \ case

ELIF _ELITE_A_DOCKED

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case, with the next
                        \ letter printing in upper case

ENDIF

 LDA TYPE               \ Set up a new ship, using the ship type in TYPE
 JSR NWSHP

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Tube

 LDY #6                 \ Move the text cursor to column 6
 STY XC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #6                 \ Move the text cursor to column 6
 JSR DOXC

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA #6                 \ Move the text cursor to column 6
 STA XC

ENDIF

IF _CASSETTE_VERSION \ Platform

 JSR DELAY              \ Delay for 6 vertical syncs (6/50 = 0.12 seconds)

ENDIF

IF NOT(_NES_VERSION)

 LDA #30                \ Print recursive token 144 ("---- E L I T E ----")
 JSR plf                \ followed by a newline

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Tube

 LDY #6                 \ Move the text cursor to column 6 again
 STY XC

 INC YC                 \ Move the text cursor down a row

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #10                \ Print a line feed to move the text cursor down a line
 JSR TT26

 LDA #6                 \ Move the text cursor to column 6 again
 JSR DOXC

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA #10                \ Print a line feed to move the text cursor down a line
 JSR TT26

 LDA #6                 \ Move the text cursor to column 6 again
 STA XC

ENDIF

IF NOT(_NES_VERSION)

 LDA PATG               \ If PATG = 0, skip the following two lines, which
 BEQ awe                \ print the author credits (PATG can be toggled by
                        \ pausing the game and pressing "X")

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #254               \ Print recursive token 94 ("BY D.BRABEN & I.BELL")
 JSR TT27

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDA #13                \ Print extended token 13 ("BY D.BRABEN & I.BELL")
 JSR DETOK

ENDIF

IF _ELITE_A_VERSION

 INC YC                 \ Move the text cursor down two rows
 INC YC

 LDA #3                 \ Move the text cursor to column 3
 STA XC

 LDA #114               \ Print extended token 114 (" MODIFIED BY A.J.C.DUGGAN")
 JSR DETOK

ENDIF

.awe

IF _MASTER_VERSION \ Platform

 LDY #0                 \ Set DELTA = 0 (i.e. ship speed = 0)
 STY DELTA

 STY JSTK               \ Set JSTK = 0 (i.e. keyboard, not joystick)

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

 LDA brkd               \ If brkd = 0, jump to BRBR2 to skip the following, as
 BEQ BRBR2              \ we do not have a system error message to display

 INC brkd               \ Increment the brkd counter

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Master: Group B: The Master version shows the "Load New Commander (Y/N)?" prompt on row 20, while the other versions show it one line lower, on row 21

 LDA #7                 \ Move the text cursor to column 7
 STA XC

 LDA #10                \ Move the text cursor to row 10
 STA YC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #7                 \ Move the text cursor to column 7
 JSR DOXC

 LDA #10                \ Move the text cursor to row 10
 JSR DOYC

ELIF _MASTER_VERSION

 LDA #20                \ Move the text cursor to row 20
 STA YC

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ELIF _APPLE_VERSION

 LDA #7                 \ Move the text cursor to column 7
 STA XC

 LDA #9                 \ Move the text cursor to row 9
 STA YC

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Platform

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

ELIF _C64_VERSION OR _APPLE_VERSION

                        \ The following loop prints out the null-terminated
                        \ message pointed to by (&FD &FE), which is the OS
                        \ error message pointer - so this prints the error
                        \ message on the next line

 LDY #0                 \ Set Y = 0 to act as a character counter

 JSR CHPR               \ Print the character in A (which contains a line feed
                        \ on the first loop iteration), and then any non-zero
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the OS error message pointer

 BNE P%-6               \ If the fetched character is non-zero, loop back to the
                        \ JSR CHPR above to print it, and keep looping until
                        \ we fetch a zero (which marks the end of the message)

.BRBR2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group B

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows.
                        \ It also returns with Y = 0

 STY DELTA              \ Set DELTA = 0 (i.e. ship speed = 0)

 STY JSTK               \ Set JSTK = 0 (i.e. keyboard, not joystick)

ELIF _C64_VERSION

 LDY #0                 \ Set DELTA = 0 (i.e. ship speed = 0)
 STY DELTA

 STY JSTK               \ Set JSTK = 0 (i.e. keyboard, not joystick)

 LDA #15                \ Move the text cursor to row 15
 STA YC

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ELIF _APPLE_VERSION

 LDY #0                 \ Set DELTA = 0 (i.e. ship speed = 0)
 STY DELTA

 STY JSTK               \ Set JSTK = 0 (i.e. keyboard, not joystick)

 LDA #14                \ Move the text cursor to row 14
 STA YC

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Master: The Master version shows the copyright year on the title screen as 1986 rather than 1984

 PLA                    \ Restore the recursive token number we stored on the
 JSR ex                 \ stack at the start of this subroutine, and print that
                        \ token

 LDA #148               \ Set A to recursive token 148

 LDX #7                 \ Move the text cursor to column 7
 STX XC

 JSR ex                 \ Print recursive token 148 ("(C) ACORNSOFT 1984")

ELIF _DISC_DOCKED OR _ELITE_A_VERSION

 PLA                    \ Restore the recursive token number we stored on the
                        \ stack at the start of this subroutine

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

ELIF _MASTER_VERSION

 PLA                    \ Restore the recursive token number we stored on the
                        \ stack at the start of this subroutine

 JSR DETOK              \ Print the extended token in A

 LDA #7                 \ Move the text cursor to column 7
 STA XC

 LDA #12                \ Print extended token 12 ("({single cap}C) ACORNSOFT
 JSR DETOK              \ 1986")

ELIF _C64_VERSION

 PLA                    \ Restore the recursive token number we stored on the
                        \ stack at the start of this subroutine

\JSR ex                 \ This instruction is commented out in the original
                        \ source (it would print the recursive token in A)

 JSR DETOK              \ Print the extended token in A

 LDA #3                 \ Move the text cursor to column 3
 JSR DOXC

 LDA #12                \ Print extended token 12 ("{single cap}C) {single
 JSR DETOK              \ cap}D.{single cap}BRABEN & {single cap}I.{single
                        \ cap}BELL 1985")

ELIF _APPLE_VERSION

 PLA                    \ Restore the recursive token number we stored on the
                        \ stack at the start of this subroutine

 JSR DETOK              \ Print the extended token in A

 LDA #3                 \ Move the text cursor to column 3
 STA XC

 LDA #12                \ Print extended token 12 ("{single cap}C) {single
 JSR DETOK              \ cap}D.{single cap}BRABEN & {single cap}I.{single
                        \ cap}BELL 1985")

ENDIF

IF _NES_VERSION

 JSR HideFromScanner_b1 \ Hide the ship from the scanner

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ 6502SP: Group C: The 6502SP version adds two loop counters to the title screen so we can start the demo after a certain period on the title screen

 LDA #12                \ Set CNT2 = 12 as the outer loop counter for the loop
 STA CNT2               \ starting at TLL2

 LDA #5                 \ Set the main loop counter in MCNT to 5, to act as the
 STA MCNT               \ inner loop counter for the loop starting at TLL2

ENDIF

IF _MASTER_VERSION \ Platform

 STZ JSTK               \ Set JSTK = 0 (i.e. keyboard, not joystick)

ELIF _C64_VERSION

 LDA #&FF               \ ???
 STA JSTK

ENDIF

IF _NES_VERSION

 LDY #0                 \ Set DELTA = 0 (i.e. ship speed = 0)
 STY DELTA

 LDA #&01               \ Clear the screen and set the view type in QQ11 to &01
 JSR ChangeToView       \ (Title screen)

 LDA #7                 \ Set YP = 7 to use as the outer loop counter for the
 STA YP                 \ loop starting at TLL2

.titl1

 LDA #25                \ Set XP = 25 to use as the inner loop counter for the
 STA XP                 \ loop starting at TLL2

ENDIF

.TLL2

 LDA INWK+7             \ If z_hi (the ship's distance) is 1, jump to TL1 to
 CMP #1                 \ skip the following decrement
 BEQ TL1

 DEC INWK+7             \ Decrement the ship's distance, to bring the ship
                        \ a bit closer to us

.TL1

IF NOT(_NES_VERSION)

 JSR MVEIT              \ Move the ship in space according to the orientation
                        \ vectors and the new value in z_hi

ELIF _NES_VERSION

 JSR titl5              \ Call titl5 below as a subroutine to rotate and move
                        \ the ship in space

 BCS titl3              \ If a button was been pressed during the ship drawing,
                        \ then the C flag sill be set, so jump to titl3 to
                        \ return from the subroutine with the C flag set to
                        \ indicate a button press

 DEC XP                 \ Decrement the inner loop counter in XP

 BNE TLL2               \ Loop back to keep the ship rotating, until the inner
                        \ loop counter is zero

 DEC YP                 \ Decrement the outer loop counter in YP

 BNE titl1              \ Loop back to keep the ship rotating, until the outer
                        \ loop counter is zero

.titl2

 LDA INWK+7             \ If z_hi (the ship's distance) is 55 or greater, jump
 CMP #55                \ to titl4 to return from the subroutine with the C flag
 BCS titl4              \ clear, as the ship has now come towards us and has
                        \ gone away again, all without any buttons being pressed

 INC INWK+7             \ Increment the ship's distance, to move the ship a bit
                        \ further away from us

 JSR titl5              \ Call titl5 below as a subroutine to rotate and move
                        \ the ship in space

 BCC titl2              \ If no button was pressed during the ship drawing, then
                        \ the C flag will be clear, so loop back to titl2 to
                        \ move the ship away from us

                        \ If a button was pressed, then the C flag will be set,
                        \ so we now return from the subroutine with the C flag
                        \ set

.titl3

 SEC                    \ Set the C flag to indicate that a button has been
                        \ pressed

 RTS                    \ Return from the subroutine

.titl4

 CLC                    \ Clear the C flag to indicate that a button has not
                        \ been pressed

 RTS                    \ Return from the subroutine

.titl5

                        \ We call this part of the code as a subroutine from
                        \ above

 JSR MV30               \ Call MV30 at the end of part 2 of MVEIT, so we move
                        \ the ship in space but without tidying the orientation
                        \ vectors or applying tactics (neither of which are
                        \ necessary on the title screen)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Minor

 LDA #128               \ Set z_lo = 128, so the closest the ship gets to us is
 STA INWK+6             \ z_hi = 1, z_lo = 128, or 256 + 128 = 384

ELIF _6502SP_VERSION

 LDX #128               \ Set z_lo = 128, so the closest the ship gets to us is
 STX INWK+6             \ z_hi = 1, z_lo = 128, or 256 + 128 = 384

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDX distaway           \ Set z_lo to the distance value we passed to the
 STX INWK+6             \ routine, so this is the closest the ship gets to us

ENDIF

IF _6502SP_VERSION \ 6502SP: The 6502SP version only scans for key presses every four iterations on the title screen (as opposed to every iteration in the other versions), so you have to hold down "Y", "N" or Space for noticeably longer to load a commander or start the game

 LDA MCNT               \ This value will be zero on one out of every four
 AND #3                 \ iterations, so for the other three, skip to nodesire
 BNE nodesire           \ so we only scan for key presses once every four loops

 STX NEEDKEY            \ Set NEEDKEY = 128, so the call to LL9 below draws the
                        \ ship and scans for key presses (LL9 resets NEEDKEY to
                        \ 0 so we have to reset NEEDKEY every four iterations
                        \ round the inner loop)

.nodesire

ELIF _NES_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA MCNT               \ This has no effect - it is presumably left over from
 AND #3                 \ the other versions of Elite which only scan the
                        \ keyboard once every four loops, but that isn't the
                        \ case here as the result is not acted upon

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Minor

 ASL A                  \ Set A = 0

 STA INWK               \ Set x_lo = 0, so the ship remains in the screen centre

 STA INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

ELIF _6502SP_VERSION

 STZ INWK               \ Set x_lo = 0, so the ship remains in the screen centre

 STZ INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDA #0                 \ Set x_lo = 0, so the ship remains in the screen centre
 STA INWK

 STA INWK+3             \ Set y_lo = 0, so the ship remains in the screen centre

ENDIF

IF NOT(_NES_VERSION)

 JSR LL9                \ Call LL9 to display the ship

ELIF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DrawShipInBitplane \ Flip the drawing bitplane and draw the current ship in
                        \ the newly flipped bitplane

ENDIF

IF _C64_VERSION OR _APPLE_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the
                        \ key in X (or 0 for no key press)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 DEC MCNT               \ Decrement the main loop counter

ELIF _NES_VERSION

 INC MCNT               \ Increment the main loop counter

ENDIF

IF _ELITE_A_DOCKED

 LDA #&51               \ Set 6522 User VIA output register ORB (SHEILA &60) to
 STA VIA+&60            \ the Delta 14B joystick button in the middle column
                        \ (high nibble &5) and top row (low nibble &1), which
                        \ corresponds to the fire button

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED \ Electron: Group D: As joysticks are not supported in the Electron version, it doesn't check for the joystick fire button being pressed during the "Press Fire Or Space,Commander." stage of the title screen

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

ELIF _6502SP_VERSION

 LDA KTRAN+12           \ Fetch the key press state for the joystick 1 fire
                        \ button from the key logger buffer, which contains
                        \ the value of the 6522 System VIA input register IRB
                        \ (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

ELIF _MASTER_VERSION

IF _SNG47

 LDA VIA+&40            \ Read 6522 System VIA input register IRB (SHEILA &40)

 AND #%00010000         \ Bit 4 of IRB (PB4) is clear if joystick 1's fire
                        \ button is pressed, otherwise it is set, so AND'ing
                        \ the value of IRB with %10000 extracts this bit

ELIF _COMPACT

 JSR RDFIRE             \ Call RDFIRE to check whether the joystick's fire
                        \ button is being pressed

 BCS TL3                \ If the C flag is set then the joystick fire button
                        \ is being pressed, so jump to TL3

ENDIF

ELIF _C64_VERSION

 BIT KY7                \ ???
 BMI TL3

ELIF _APPLE_VERSION

 LDA &C061              \ ???
 ORA &C062

IF _IB_DISK

 AND L4562              \ ???

ENDIF

 BMI TL3

ELIF _ELITE_A_6502SP_PARA

 JSR scan_fire          \ Call scan_fire to check whether the joystick's fire
                        \ button is being pressed, which clears bit 4 in A if
                        \ the fire button is being pressed, and sets it if it
                        \ is not being pressed

ELIF _NES_VERSION

 LDA controller1A       \ If any of the A button, Start or Select are being
 ORA controller1Start   \ pressed on controller 1, jump to tite1 to check the
 ORA controller1Select  \ same buttons on controller 2, as these don't count as
 BMI tite1              \ a button press until they are released

 BNE tite3              \ If the result is non-zero, then at least one of the
                        \ A button, Start or Select were being pressed but have
                        \ now been released, so jump to tite3 to set the number
                        \ of pilots to one (as the buttons are being pressed on
                        \ controller 1), and return from the subroutine with
                        \ the C flag set, to indicate the button press

.tite1

 LDA controller2A       \ If any of the A button, Start or Select are being
 ORA controller2Start   \ pressed on controller 2, jump to tite2 to return from
 ORA controller2Select  \ the subroutine with the C flag clear, as these don't
 BMI tite2              \ count as a button press until they are released

 BNE tite4              \ If the result is non-zero, then at least one of the
                        \ A button, Start or Select were being pressed but have
                        \ now been released, so jump to tite4 to keep the number
                        \ of pilots to two (as the buttons are being pressed on
                        \ controller 2) to return from the subroutine with the
                        \ C flag set, to indicate the button press

.tite2

 CLC                    \ Clear the C flag to indicate that a button has not
                        \ been pressed

 RTS                    \ Return from the subroutine

.tite3

 LSR numberOfPilots     \ Set numberOfPilots = 0 to configure the game for one
                        \ pilot

.tite4

 SEC                    \ Set the C flag to indicate that a button has been
                        \ pressed

 RTS                    \ Return from the subroutine

ENDIF

IF _CASSETTE_VERSION \ Minor

\TAX                    \ This instruction is commented out in the original
                        \ source; it would have no effect, as the comparison
                        \ flags are already set by the AND, and the value of X
                        \ is not used anywhere

ELIF _6502SP_VERSION

 TAX                    \ Copy the joystick fire button state to X, though this
                        \ instruction has no effect, as the comparison flags are
                        \ already set by the AND, and the value of X is not used
                        \ anywhere

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Electron: See group D

 BEQ TL2                \ If the joystick fire button is pressed, jump to TL2

ELIF _MASTER_VERSION

IF _SNG47

 BEQ TL3                \ If the joystick fire button is pressed, jump to TL3

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 JSR RDKEY              \ Scan the keyboard for a key press

 BEQ TLL2               \ If no key was pressed, loop back up to move/rotate
                        \ the ship and check again for a key press

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA KTRAN              \ Fetch the internal key number of the current key
                        \ press from the key logger buffer

 BNE TL3                \ If a key is being pressed, jump to TL3

ELIF _C64_VERSION

 BCC TLL2               \ ???

ELIF _APPLE_VERSION

 BCC TLL2               \ ???

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION \ 6502SP: See group C

 DEC MCNT               \ Decrement the inner loop counter

 BNE TLL2               \ Loop back to keep the ship rotating, until the inner
                        \ loop counter is zero

 DEC CNT2               \ Decrement the outer loop counter in CNT2

 BNE TLL2               \ Loop back to keep the ship rotating, until the outer
                        \ loop counter is zero

 JMP DEMON              \ Once we have iterated through CNT2 iterations of MCNT,
                        \ jump to DEMON to start the demo

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ Electron: See group D

.TL2

 DEC JSTK               \ Joystick fire button was pressed, so set JSTK to &FF
                        \ (it was set to 0 above), to disable keyboard and
                        \ enable joysticks

ELIF _MASTER_VERSION OR _APPLE_VERSION

.TL3

 DEC JSTK               \ Joystick fire button was pressed, so set JSTK to &FF
                        \ (it was set to 0 above), to disable keyboard and
                        \ enable joysticks

ELIF _6502SP_VERSION

.TL2

 DEC JSTK               \ Joystick fire button was pressed, so set JSTK to &FF
                        \ (it was set to 0 above), to disable keyboard and
                        \ enable joysticks

.TL3

ELIF _C64_VERSION

 INC JSTK               \ ???

.TL3

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 RTS                    \ Return from the subroutine

ENDIF

