\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Comment
\       Name: TT26
ELIF _DISC_DOCKED OR _C64_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION
\       Name: CHPR
ENDIF
\       Type: Subroutine
\   Category: Text
IF NOT(_ELITE_A_6502SP_PARA)
\    Summary: Print a character at the text cursor by poking into screen memory
ELIF _ELITE_A_6502SP_PARA
\    Summary: Print a character at the text cursor by sending a write_xyc
\             command to the I/O processor
ENDIF
\  Deep dive: Drawing text
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ WRCHV is set to point here by the loading process.
ELIF _6502SP_VERSION OR _MASTER_VERSION
\ Calls to OSWRCH will end up here when A is not in the range 128-147, as those
\ are reserved for the special jump table OSWRCH commands.
ELIF _C64_VERSION
\ The CHPR2 sends characters here for printing if they are in the range 13-122.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 7 (beep)
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\                         * 10-13 (line feeds and carriage returns)
ELIF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION
\                         * 10 (line feed)
\
\                         * 11 (clear the top part of the screen and draw a
\                           border)
\
\                         * 12-13 (carriage return)
ENDIF
\
\                         * 32-95 (ASCII capital letters, numbers and
\                           punctuation)
\
\                         * 127 (delete the character to the left of the text
\                           cursor and move the cursor to the left)
\
\   XC                  Contains the text column to print at (the x-coordinate)
\
\   YC                  Contains the line number to print on (the y-coordinate)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
\   C flag              The C flag is cleared
\
ENDIF
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
IF _CASSETTE_VERSION \ Comment
\   RR3+1               Contains an RTS
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Comment
\   RREN                Prints the character definition pointed to by P(2 1) at
\                       the screen address pointed to by (A SC). Used by the
\                       BULB routine
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Comment
\   rT9                 Contains an RTS
\
ENDIF
IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Comment
\   R5-1                Contains an RTS
\
ENDIF
IF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment
\   RR4                 Restore the registers and return from the subroutine
\
ENDIF
IF _C64_VERSION
\   RRafter             A re-entry point from the clss routine to print the
\                       character in A
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _6502SP_VERSION \ Label

.TT26

ELIF _DISC_DOCKED OR _C64_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

.CHPR

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Minor

 STA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

ELIF _6502SP_VERSION

 STA K3                 \ Store the A, X and Y registers, so we can restore
 TYA                    \ them at the end (so they don't get changed by this
 PHA                    \ routine)
 TXA
 PHA
 LDA K3

ELIF _MASTER_VERSION

 STA K3                 \ Store the A, X and Y registers, so we can restore
 PHY                    \ them at the end (so they don't get changed by this
 PHX                    \ routine)

ENDIF

IF _ELITE_A_DOCKED

IF _BUG_FIX

 JSR SwitchToCharSet    \ Switch &C000 to the MOS character definitions if we
                        \ are printing while there is disc activity

ENDIF

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA \ Label

.RRNEW

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Platform

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Minor

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ RR4                \ RR4, which doesn't print anything, it just restores
                        \ the registers and returns from the subroutine

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA

 INY                    \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ RR4                \ RR4, which doesn't print anything, it just restores
                        \ the registers and returns from the subroutine

ELIF _MASTER_VERSION OR _C64_VERSION

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ RR4S               \ RR4 (via the JMP in RR4S) to restore the registers
                        \ and return from the subroutine using a tail call

ENDIF

IF _C64_VERSION

.RRafter

ENDIF

IF _MASTER_VERSION \ Master: Group A: The Master Compact release prints the disc catalogue using different logic, as the Compact uses ADFS rather than DFS

IF _COMPACT

 TAY                    \ Copy the character to be printed from A into Y

 BEQ RR4S               \ If the character to be printed is 0 or >= 128, jump to
 BMI RR4S               \ RR4S (via the JMP in RR4S) to restore the registers
                        \ and return from the subroutine using a tail call

.RRNEW

ENDIF

ENDIF

IF _MASTER_VERSION \ Platform

 LDY #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STY VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA \ Master: See group A

 TAY                    \ Set Y = the character to be printed

 BEQ RR4                \ If the character is zero, which is typically a string
                        \ terminator character, jump down to RR4 to restore the
                        \ registers and return from the subroutine

 BMI RR4                \ If A > 127 then there is nothing to print, so jump to
                        \ RR4 to restore the registers and return from the
                        \ subroutine

ELIF _6502SP_VERSION

 TAY                    \ Set Y = the character to be printed

 BEQ RR4S               \ If the character is zero, which is typically a string
                        \ terminator character, jump down to RR4 (via the JMP in
                        \ RR4S) to restore the registers and return from the
                        \ subroutine using a tail call

ELIF _MASTER_VERSION

 TAY                    \ Set Y = the character to be printed

IF _SNG47

 BEQ RR4S               \ If the character is zero, which is typically a string
                        \ terminator character, jump down to RR4 (via the JMP in
                        \ RR4S) to restore the registers and return from the
                        \ subroutine using a tail call

 BMI RR4S               \ If A > 127 then there is nothing to print, so jump to
                        \ RR4 (via the JMP in RR4S) to restore the registers and
                        \ return from the subroutine

ELIF _COMPACT

 LDX CATF               \ If CATF <> 0, skip the following two instructions, as
 BNE P%+6               \ we are printing a disc catalogue and we don't want any
                        \ control characters lurking in the catalogue to trigger
                        \ the screen clearing routine

ENDIF

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: The advanced versions support an extra control code in the standard text token system: control code 11 clears the screen

 CMP #11                \ If this is control code 11 (clear screen), jump to cls
 BEQ cls                \ to clear the top part of the screen, draw a white
                        \ border and return from the subroutine via RR4

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Minor

 CMP #7                 \ If this is a beep character (A = 7), jump to R5,
 BEQ R5                 \ which will emit the beep, restore the registers and
                        \ return from the subroutine

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CMP #7                 \ If this is not control code 7 (beep), skip the next
 BNE P%+5               \ instruction

 JMP R5                 \ This is control code 7 (beep), so jump to R5 to make
                        \ a beep and return from the subroutine via RR4

ENDIF

 CMP #32                \ If this is an ASCII character (A >= 32), jump to RR1
 BCS RR1                \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ RRX1               \ RRX1, which will move down a line, restore the
                        \ registers and return from the subroutine

IF _C64_VERSION

.RRX2

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform: The cassette version uses control code 12 for a newline, while the other versions use 13

 LDX #1                 \ If we get here, then this is control code 11-13, of
 STX XC                 \ which only 13 is used. This code prints a newline,
ELIF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION

 LDX #1                 \ If we get here, then this is control code 12 or 13,
 STX XC                 \ both of which are used. This code prints a newline,
ENDIF
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA \ Platform

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ RR4                \ RR4 to restore the registers and return from the
                        \ subroutine

ENDIF

.RRX1

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 INC YC                 \ Print a line feed, simply by incrementing the row
                        \ number (y-coordinate) of the text cursor, which is
                        \ stored in YC

 BNE RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine (this BNE is effectively a JMP as Y
                        \ will never be zero)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ RR4S               \ to RR4 (via the JMP in RR4S) to restore the registers
                        \ and return from the subroutine using a tail call

 INC YC                 \ Increment the text cursor y-coordinate to move it
                        \ down one row

.RR4S

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

ELIF _C64_VERSION

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ RR4S               \ to RR4 (via the JMP in RR4S) to restore the registers
                        \ and return from the subroutine using a tail call

 INC YC                 \ Increment the text cursor y-coordinate to move it
                        \ down one row

 BNE RR4S               \ Jump to RR4 via RR4S to restore the registers and
                        \ return from the subroutine using a tail call

ENDIF

.RR1

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95. The quickest way
                        \ to display text on-screen is to poke the character
                        \ pixel by pixel, directly into screen memory, so
                        \ that's what the rest of this routine does
                        \
IF NOT(_C64_VERSION)
                        \ The first step, then, is to get hold of the bitmap
                        \ definition for the character we want to draw on the
                        \ screen (i.e. we need the pixel shape of this
                        \ character). The MOS ROM contains bitmap definitions
                        \ of the system's ASCII characters, starting from &C000
                        \ for space (ASCII 32) and ending with the £ symbol
                        \ (ASCII 126)
ELIF _C64_VERSION
                        \ The first step, then, is to get hold of the bitmap
                        \ definition for the character we want to draw on the
                        \ screen (i.e. we need the pixel shape of this
                        \ character)
                        \
                        \ The Commodore 64 version of Elite uses the same
                        \ character bitmaps as the BBC Micro version of Elite,
                        \ which in turn uses the characters from the BBC Micro's
                        \ MOS operating system
                        \
                        \ A copy of these bitmap definitions is embedded into
                        \ this source code at page FONT, so page 0 of the font
                        \ is at FONT, page 1 is at FONT+1, and page 2 at
                        \ FONT+2
ENDIF
IF _6502SP_VERSION \ Comment
                        \
                        \ To save time looking this information up from the MOS
                        \ ROM a copy of these bitmap definitions is embedded
                        \ into this source code at page FONT%, so page 0 of the
                        \ font is at FONT%, page 1 is at FONT%+1, and page 2 at
                        \ FONT%+2
ENDIF
                        \
                        \ There are definitions for 32 characters in each of the
                        \ three pages of MOS memory, as each definition takes up
                        \ 8 bytes (8 rows of 8 pixels) and 32 * 8 = 256 bytes =
                        \ 1 page. So:
                        \
                        \   ASCII 32-63  are defined in &C000-&C0FF (page 0)
                        \   ASCII 64-95  are defined in &C100-&C1FF (page 1)
                        \   ASCII 96-126 are defined in &C200-&C2F0 (page 2)
                        \
                        \ The following code reads the relevant character
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
                        \ bitmap from the above locations in ROM and pokes
ELIF _6502SP_VERSION
                        \ bitmap from the copied MOS bitmaps at FONT% and pokes
ELIF _C64_VERSION
                        \ bitmap from the copied MOS bitmaps at FONT and pokes
ENDIF
                        \ those values into the correct position in screen
                        \ memory, thus printing the character on-screen
                        \
                        \ It's a long way from 10 PRINT "Hello world!":GOTO 10

IF _CASSETTE_VERSION \ Comment

\LDX #LO(K3)            \ These instructions are commented out in the original
\INX                    \ source, but they call OSWORD 10, which reads the
\STX P+1                \ character bitmap for the character number in K3 and
\DEX                    \ stores it in the block at K3+1, while also setting
\                       \ P+1 to point to the character definition. This is
\LDY #HI(K3)            \ exactly what the following uncommented code does,
\STY P+2                \ just without calling OSWORD. Presumably the code
\                       \ below is faster than using the system call, as this
\LDA #10                \ version takes up 15 bytes, while the version below
\JSR OSWORD             \ (which ends with STA P+1 and SYX P+2) is 17 bytes.
                        \ Every efficiency saving helps, especially as this
                        \ routine is run each time the game prints a character
                        \
                        \ If you want to switch this code back on, uncomment
                        \ the above block, and comment out the code below from
                        \ TAY to STX P+2. You will also need to uncomment the
                        \ LDA YC instruction a few lines down (in RR2), just to
                        \ make sure the rest of the code doesn't shift in
                        \ memory. To be honest I can't see a massive difference
                        \ in speed, but there you go

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 TAY                    \ Copy the character number from A to Y, as we are
                        \ about to pull A apart to work out where this
                        \ character definition lives in memory

ENDIF

                        \ Now we want to set X to point to the relevant page
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
                        \ number for this character - i.e. &C0, &C1 or &C2.
ELIF _6502SP_VERSION
                        \ number for this character - i.e. FONT% to FONT%+2
ELIF _C64_VERSION
                        \ number for this character - i.e. FONT to FONT+2
ENDIF

                        \ The following logic is easier to follow if we look
                        \ at the three character number ranges in binary:
                        \
                        \   Bit #  76543210
                        \
                        \   32  = %00100000     Page 0 of bitmap definitions
                        \   63  = %00111111
                        \
                        \   64  = %01000000     Page 1 of bitmap definitions
                        \   95  = %01011111
                        \
                        \   96  = %01100000     Page 2 of bitmap definitions
                        \   125 = %01111101
                        \
                        \ We'll refer to this below

IF _6502SP_VERSION \ Platform

\BEQ RR4                \ This instruction is commented out in the original
                        \ source, but it would return from the subroutine if A
                        \ is zero

 BPL P%+5               \ If the character number is positive (i.e. A < 128)
                        \ then skip the following instruction

 JMP RR4                \ A >= 128, so jump to RR4 to restore the registers and
                        \ return from the subroutine using a tail call

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Platform

 LDX #&BF               \ Set X to point to the first font page in ROM minus 1,
                        \ which is &C0 - 1, or &BF

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX #(FONT%-1)         \ Set X to point to the page before the first font page,
                        \ which is FONT% - 1

ELIF _C64_VERSION

 LDX #HI(FONT)-1        \ Set X to point to the page before the first font page,
                        \ which is HI(FONT) - 1

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 ASL A                  \ If bit 6 of the character is clear (A is 32-63)
 ASL A                  \ then skip the following instruction
 BCC P%+4

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Platform

 LDX #&C1               \ A is 64-126, so set X to point to page &C1

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDX #(FONT%+1)         \ A is 64-126, so set X to point to page FONT% + 1

ELIF _C64_VERSION

 LDX #HI(FONT)+1        \ A is 64-126, so set X to point to the after the first
                        \ font page, which is HI(FONT) + 1

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 ASL A                  \ If bit 5 of the character is clear (A is 64-95)
 BCC P%+3               \ then skip the following instruction

 INX                    \ Increment X
                        \
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Comment
                        \ By this point, we started with X = &BF, and then
                        \ we did the following:
                        \
                        \   If A = 32-63:   skip    then INX  so X = &C0
                        \   If A = 64-95:   X = &C1 then skip so X = &C1
                        \   If A = 96-126:  X = &C1 then INX  so X = &C2
                        \
ELIF _6502SP_VERSION
                        \ By this point, we started with X = FONT%-1, and then
                        \ we did the following:
                        \
                        \   If A = 32-63:   skip        then INX  so X = FONT%
                        \   If A = 64-95:   X = FONT%+1 then skip so X = FONT%+1
                        \   If A = 96-126:  X = FONT%+1 then INX  so X = FONT%+2
                        \
ELIF _C64_VERSION
                        \ By this point, we started with X = FONT-1, and then
                        \ we did the following:
                        \
                        \   If A = 32-63:   skip       then INX  so X = FONT
                        \   If A = 64-95:   X = FONT+1 then skip so X = FONT+1
                        \   If A = 96-126:  X = FONT+1 then INX  so X = FONT+2
                        \
ENDIF
IF NOT(_ELITE_A_6502SP_PARA)
                        \ In other words, X points to the relevant page. But
                        \ what about the value of A? That gets shifted to the
                        \ left three times during the above code, which
                        \ multiplies the number by 8 but also drops bits 7, 6
                        \ and 5 in the process. Look at the above binary
                        \ figures and you can see that if we cleared bits 5-7,
                        \ then that would change 32-53 to 0-31... but it would
                        \ do exactly the same to 64-95 and 96-125. And because
                        \ we also multiply this figure by 8, A now points to
                        \ the start of the character's definition within its
                        \ page (because there are 8 bytes per character
                        \ definition)
                        \
                        \ Or, to put it another way, X contains the high byte
                        \ (the page) of the address of the definition that we
                        \ want, while A contains the low byte (the offset into
                        \ the page) of the address
ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Minor

 STA P+1                \ Store the address of this character's definition in
 STX P+2                \ P(2 1)

ELIF _6502SP_VERSION

 STA Q                  \ R is the same location as Q+1, so this stores the
 STX R                  \ address of this character's definition in Q(1 0)

ELIF _MASTER_VERSION

 STA P                  \ Store the address of this character's definition in
 STX P+1                \ P(1 0)

ENDIF

IF _ELECTRON_VERSION \ Screen

 LDA #128               \ Set SC = 128 for use in the calculation below
 STA SC

 LDA YC                 \ If YC < 24 then we are in the top part of the screen,
 CMP #24                \ so skip the following two instructions
 BCC P%+8

 JSR TTX66              \ We are off the bottom of the screen, so we don't want
                        \ to print anything, so first clear the screen and draw
                        \ a border box

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine

                        \ The text row is on-screen, so now to calculate the
                        \ screen address we need to write to, as follows:
                        \
                        \   SC = &5800 + (char row * 256) + (char row * 64) + 32

 LSR A                  \ Set (A SC) = (A SC) / 4
 ROR SC                 \            = (4 * ((char row * 64) + 32)) / 4
 LSR A                  \            = char row * 64 + 32
 ROR SC

 ADC YC                 \ Set SC(1 0) = (A SC) + (YC 0) + &5800
 ADC #&58               \             = (char row * 64 + 32)
 STA SC+1               \               + char row * 256
                        \               + &5800
                        \
                        \ which is what we want, so SC(1 0) contains the address
                        \ of the first visible pixel on the character row we
                        \ want

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 LDA XC                 \ Fetch XC, the x-coordinate (column) of the text cursor
                        \ into A

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Enhanced: The standard disc catalogue is just too wide to fit into Elite's special square screen mode, so when printing the catalogue in the enhanced versions, a space is removed from column 17, which is always a blank column in the middle of the catalogue

 LDX CATF               \ If CATF = 0, jump to RR5, otherwise we are printing a
 BEQ RR5                \ disc catalogue

 CPY #' '               \ If the character we want to print in Y is a space,
 BNE RR5                \ jump to RR5

                        \ If we get here, then CATF is non-zero, so we are
                        \ printing a disc catalogue and we are not printing a
                        \ space, so we drop column 17 from the output so the
                        \ catalogue will fit on-screen (column 17 is a blank
                        \ column in the middle of the catalogue, between the
                        \ two lists of filenames, so it can be dropped without
                        \ affecting the layout). Without this, the catalogue
                        \ would be one character too wide for the square screen
                        \ mode (it's 34 characters wide, while the screen mode
                        \ is only 33 characters across)

 CMP #17                \ If A = 17, i.e. the text cursor is in column 17, jump
 BEQ RR4                \ to RR4 to restore the registers and return from the
                        \ subroutine, thus omitting this column

.RR5

ELIF _MASTER_VERSION

 LDX CATF               \ If CATF = 0, jump to RR5, otherwise we are printing a
 BEQ RR5                \ disc catalogue

IF _SNG47

 CPY #' '               \ If the character we want to print in Y is a space,
 BNE RR5                \ jump to RR5

                        \ If we get here, then CATF is non-zero, so we are
                        \ printing a disc catalogue and we are not printing a
                        \ space, so we drop column 17 from the output so the
                        \ catalogue will fit on-screen (column 17 is a blank
                        \ column in the middle of the catalogue, between the
                        \ two lists of filenames, so it can be dropped without
                        \ affecting the layout). Without this, the catalogue
                        \ would be one character too wide for the square screen
                        \ mode (it's 34 characters wide, while the screen mode
                        \ is only 33 characters across)

 CMP #17                \ If A = 17, i.e. the text cursor is in column 17, jump
 BEQ RR4                \ to RR4 to restore the registers and return from the
                        \ subroutine, thus omitting this column

ELIF _COMPACT

 CMP #21                \ If A < 21, i.e. the text cursor is in column 0-20,
 BCC RR5                \ jump to RR5 to skip the following

                        \ If we get here, then CATF is non-zero, so we are
                        \ printing a disc catalogue and we have reached column
                        \ 21, so we move to the start of the next line so the
                        \ catalogue line-wraps to fit within the bounds of the
                        \ screen

 INC YC                 \ More the text cursor down a line

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ENDIF

.RR5

ELIF _C64_VERSION

 CMP #31                \ If A >= 31, i.e. the text cursor past the right edge
 BCS RRX2               \ the screen, jump to RRX2 to move to column 1

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

 ASL A                  \ Multiply A by 8, and store in SC. As each character is
 ASL A                  \ 8 pixels wide, and the special screen mode Elite uses
 ASL A                  \ for the top part of the screen is 256 pixels across
 STA SC                 \ with one bit per pixel, this value is not only the
                        \ screen address offset of the text cursor from the left
                        \ side of the screen, it's also the least significant
                        \ byte of the screen address where we want to print this
                        \ character, as each row of on-screen pixels corresponds
                        \ to one page. To put this more explicitly, the screen
                        \ starts at &6000, so the text rows are stored in screen
                        \ memory like this:
                        \
                        \   Row 1: &6000 - &60FF    YC = 1, XC = 0 to 31
                        \   Row 2: &6100 - &61FF    YC = 2, XC = 0 to 31
                        \   Row 3: &6200 - &62FF    YC = 3, XC = 0 to 31
                        \
                        \ and so on

ELIF _ELECTRON_VERSION

 ASL A                  \ Multiply A by 8, and add to SC. As each character is
 ASL A                  \ 8 pixels wide, this gives us the screen address of the
 ASL A                  \ character block where we want to print this character
 ADC SC
 STA SC

 BCC P%+4               \ If the addition of the low byte overflowed, increment
 INC SC+1               \ the high byte

ELIF _6502SP_VERSION OR _MASTER_VERSION

 ASL A                  \ Multiply A by 8, and store in SC, so we now have:
 ASL A                  \
 ASL A                  \   SC = XC * 8
 STA SC

ELIF _C64_VERSION

 LDA #&80               \ Set SC to &80 so we can use it in the calculation of
 STA SC                 \ the character's screen address below

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 INC XC                 \ Move the text cursor to the right by one column

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA YC                 \ Fetch YC, the y-coordinate (row) of the text cursor

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Platform

 CPY #127               \ If the character number (which is in Y) <> 127, then
 BNE RR2                \ skip to RR2 to print that character, otherwise this is
                        \ the delete character, so continue on

 DEC XC                 \ We want to delete the character to the left of the
                        \ text cursor and move the cursor back one, so let's
                        \ do that by decrementing YC. Note that this doesn't
                        \ have anything to do with the actual deletion below,
                        \ we're just updating the cursor so it's in the right
                        \ position following the deletion

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Platform

 ADC #&5E               \ A contains YC (from above) and the C flag is set (from
 TAX                    \ the CPY #127 above), so these instructions do this:
                        \
                        \   X = YC + &5E + 1
                        \     = YC + &5F

                        \ Because YC starts at 0 for the first text row, this
                        \ means that X will be &5F for row 0, &60 for row 1 and
                        \ so on. In other words, X is now set to the page number
                        \ for the row before the one containing the text cursor,
                        \ and given that we set SC above to point to the offset
                        \ in memory of the text cursor within the row's page,
                        \ this means that (X SC) now points to the character
                        \ above the text cursor

ELIF _ELECTRON_VERSION

 DEC SC+1               \ Decrement the high byte of the screen address to point
                        \ to the address of the current character, minus one
                        \ page

ELIF _6502SP_VERSION OR _MASTER_VERSION

 ASL A                  \ A contains YC (from above), so this sets A = YC * 2

 ASL SC                 \ Double the low byte of SC(1 0), catching bit 7 in the
                        \ C flag. As each character is 8 pixels wide, and the
                        \ special screen mode Elite uses for the top part of the
                        \ screen is 256 pixels across with two bits per pixel,
                        \ this value is not only double the screen address
                        \ offset of the text cursor from the left side of the
                        \ screen, it's also the least significant byte of the
                        \ screen address where we want to print this character,
                        \ as each row of on-screen pixels corresponds to two
                        \ pages. To put this more explicitly, the screen starts
                        \ at &4000, so the text rows are stored in screen
                        \ memory like this:
                        \
                        \   Row 1: &4000 - &41FF    YC = 1, XC = 0 to 31
                        \   Row 2: &4200 - &43FF    YC = 2, XC = 0 to 31
                        \   Row 3: &4400 - &45FF    YC = 3, XC = 0 to 31
                        \
                        \ and so on

 ADC #&3F               \ Set X = A
 TAX                    \       = A + &3F + C
                        \       = YC * 2 + &3F + C

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Platform

 LDY #&F8               \ Set Y = &F8, so the following call to ZES2 will count
                        \ Y upwards from &F8 to &FF

 JSR ZES2               \ Call ZES2, which zero-fills from address (X SC) + Y to
                        \ (X SC) + &FF. (X SC) points to the character above the
                        \ text cursor, and adding &FF to this would point to the
                        \ cursor, so adding &F8 points to the character before
                        \ the cursor, which is the one we want to delete. So
                        \ this call zero-fills the character to the left of the
                        \ cursor, which erases it from the screen

ELIF _ELECTRON_VERSION

 LDY #&F8               \ Set Y = &F8, so the following call to ZES2 will count
                        \ Y upwards from &F8 to &FF

 JSR ZES2               \ Call ZES2, which zero-fills from address SC(1 0) + Y
                        \ to SC(1 0) + &FF. SC(1 0) points to the address of the
                        \ current character, minus one page, and adding &FF to
                        \ this would point to the cursor, so adding &F8 points
                        \ to the character before the cursor, which is the one
                        \ we want to delete. So this call zero-fills the
                        \ character to the left of the cursor, which erases it
                        \ from the screen

ELIF _6502SP_VERSION OR _MASTER_VERSION
                        \ Because YC starts at 0 for the first text row, this
                        \ means that X will be &3F for row 0, &41 for row 1 and
                        \ so on. In other words, X is now set to the page number
                        \ for the row before the one containing the text cursor,
                        \ and given that we set SC above to point to the offset
                        \ in memory of the text cursor within the row's page,
                        \ this means that (X SC) now points to the character
                        \ above the text cursor

 LDY #&F0               \ Set Y = &F0, so the following call to ZES2 will count
                        \ Y upwards from &F0 to &FF

 JSR ZES2               \ Call ZES2, which zero-fills from address (X SC) + Y to
                        \ (X SC) + &FF. (X SC) points to the character above the
                        \ text cursor, and adding &FF to this would point to the
                        \ cursor, so adding &F0 points to the character before
                        \ the cursor, which is the one we want to delete. So
                        \ this call zero-fills the character to the left of the
                        \ cursor, which erases it from the screen

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _MASTER_VERSION \ Platform

 BEQ RR4                \ We are done deleting, so restore the registers and
                        \ return from the subroutine (this BNE is effectively
                        \ a JMP as ZES2 always returns with the Z flag set)

.RR2

                        \ Now to actually print the character

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing
                        \ XC. Note that this doesn't have anything to do
                        \ with the actual printing below, we're just updating
                        \ the cursor so it's in the right position following
                        \ the print

ENDIF

IF _CASSETTE_VERSION \ Comment

\LDA YC                 \ This instruction is commented out in the original
                        \ source. It isn't required because we only just did a
                        \ LDA YC before jumping to RR2, so this is presumably
                        \ an example of the authors squeezing the code to save
                        \ 2 bytes and 3 cycles
                        \
                        \ If you want to re-enable the commented block near the
                        \ start of this routine, you should uncomment this
                        \ instruction as well

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Screen

 CMP #24                \ If the text cursor is on the screen (i.e. YC < 24, so
 BCC RR3                \ we are on rows 0-23), then jump to RR3 to print the
                        \ character

ELIF _ELECTRON_VERSION

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &85 &08, or BIT &0885, which does nothing apart
                        \ from affect the flags. We skip the instruction as we
                        \ already set the value of SC+1 above

ENDIF

IF _CASSETTE_VERSION \ Platform

 JSR TTX66              \ Otherwise we are off the bottom of the screen, so
                        \ clear the screen and draw a border box

 JMP RR4                \ And restore the registers and return from the
                        \ subroutine

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 JSR TT66               \ Otherwise we are off the bottom of the screen, so
                        \ clear the screen and draw a border box

 JMP RR4                \ And restore the registers and return from the
                        \ subroutine

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA

 PHA                    \ Store A on the stack so we can retrieve it below

 JSR TTX66              \ Otherwise we are off the bottom of the screen, so
                        \ clear the screen and draw a border box

 PLA                    \ Retrieve A from the stack... only to overwrite it with
                        \ the next instruction, so presumably we didn't need to
                        \ preserve it and this and the PHA above have no effect

 LDA K3                 \ Set A to the character to be printed

 JMP RRNEW              \ Jump back to RRNEW to print the character

ELIF _6502SP_VERSION

 PHA                    \ Store A on the stack so we can retrieve it below

 JSR TTX66              \ Otherwise we are off the bottom of the screen, so
                        \ clear the screen and draw a border box

 LDA #1                 \ Move the text cursor to column 1, row 1
 STA XC
 STA YC

 PLA                    \ Retrieve A from the stack... only to overwrite it with
                        \ the next instruction, so presumably we didn't need to
                        \ preserve it and this and the PHA above have no effect

 LDA K3                 \ Set A to the character to be printed, though again
                        \ this has no effect, as the following call to RR4 does
                        \ the exact same thing

 JMP RR4                \ And restore the registers and return from the
                        \ subroutine

ELIF _MASTER_VERSION

IF _SNG47

 JSR TTX66              \ Otherwise we are off the bottom of the screen, so
                        \ clear the screen and draw a border box

 LDA #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ELIF _COMPACT

 LDA CATF               \ If CATF = 0, skip the next two instructions, as we are
 BEQ P%+7               \ not printing a disc catalogue

 JSR RETURN             \ We have just printed the disc catalogue, so wait until
 BPL P%-3               \ RETURN is pressed, looping indefinitely until it gets
                        \ tapped

 JSR TTX66              \ Call TTX66 to clear the screen

ENDIF

 LDA #1                 \ Move the text cursor to column 1, row 1
 STA XC
 STA YC

 LDA K3                 \ Set A to the character to be printed, though again
                        \ this has no effect, as the following call to RR4 does
                        \ the exact same thing

IF _SNG47

 JMP RR4                \ And restore the registers and return from the
                        \ subroutine

ELIF _COMPACT

 JMP RRNEW              \ Jump back to RRNEW to print the character

ENDIF

ELIF _C64_VERSION

 JMP clss               \ Otherwise we are off the bottom of the screen, so call
                        \ clss to clear the screen and draw a border box,
                        \ before jumping back to RRafter with A set to the
                        \ character to be printed at the top of the newly
                        \ cleared screen

ENDIF

.RR3

IF NOT(_ELITE_A_6502SP_PARA)

                        \ A contains the value of YC - the screen row where we
                        \ want to print this character - so now we need to
                        \ convert this into a screen address, so we can poke
                        \ the character data to the right place in screen
                        \ memory

ElIF _ELITE_A_6502SP_PARA

 LDA #&8E               \ Send command &8E to the I/O processor:
 JSR tube_write         \
                        \   write_xyc(x, y, char)
                        \
                        \ which will draw the text character in char at column x
                        \ and row y

 LDA XC                 \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * x = XC

 LDA YC                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * y = YC

 TYA                    \ Send the third parameter to the I/O processor:
 JSR tube_write         \
                        \   * char = the character in Y

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing
                        \ XC. Note that this doesn't have anything to do
                        \ with the actual printing below, we're just updating
                        \ the cursor so it's in the right position following
                        \ the print

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

 ORA #&60               \ We already stored the least significant byte
                        \ of this screen address in SC above (see the STA SC
                        \ instruction above), so all we need is the most
                        \ significant byte. As mentioned above, in Elite's
                        \ square mode 4 screen, each row of text on-screen
                        \ takes up exactly one page, so the first row is page
                        \ &60xx, the second row is page &61xx, so we can get
                        \ the page for character (XC, YC) by OR'ing with &60.
                        \ To see this in action, consider that our two values
                        \ are, in binary:
                        \
                        \   YC is between:  %00000000
                        \             and:  %00010111
                        \          &60 is:  %01100000
                        \
                        \ so YC OR &60 effectively adds &60 to YC, giving us
                        \ the page number that we want

ELIF _6502SP_VERSION OR _MASTER_VERSION

 ASL A                  \ Set A = 2 * A
                        \       = 2 * YC

 ASL SC                 \ Back in RR5 we set SC = XC * 8, so this does the
                        \ following:
                        \
                        \   SC = SC * 2
                        \      = XC * 16
                        \
                        \ so SC contains the low byte of the screen address we
                        \ want to poke the character into, as each text
                        \ character is 8 pixels wide, and there are four pixels
                        \ per byte, so the offset within the row's 512 bytes
                        \ is XC * 8 pixels * 2 bytes for each 8 pixels = XC * 16

 ADC #&40               \ Set A = &40 + A
                        \       = &40 + (2 * YC)
                        \
                        \ so A contains the high byte of the screen address we
                        \ want to poke the character into, as screen memory
                        \ starts at &4000 (page &40) and each screen row takes
                        \ up 2 pages (512 bytes)

ELIF _C64_VERSION

 LSR A                  \ Set (A SC) = (A SC) >> 2
 ROR SC                 \            = (YC &80) / 4
 LSR A                  \            = (YC * 256 / 4) + (&80 / 4)
 ROR SC                 \            = YC * 64 + &20
                        \
                        \ This also clears the C flag, as the low bits of SC are
                        \ all zeroes

 ADC YC                 \ Set A = A + YC
                        \
                        \ So (A SC) = (A SC) + (YC 0)
                        \           = YC * 64 + &20 + YC * 256
                        \           = YC * 320 + 32

 ADC #HI(SCBASE)        \ The low byte of the screen bitmap address in SCBASE is
 STA SC+1               \ always zero, so this does the following:
                        \
                        \   SC(1 0) = SCBASE + (A SC)
                        \           = SCBASE + YC * 320 + 32
                        \
                        \ So SC(1 0) contains the screen address we want to poke
                        \ the character into, because:
                        \
                        \   * The screen bitmap starts at SCBASE
                        \
                        \   * Each character row of 40 character blocks takes up
                        \     40 * 8 = 320 bytes, and we want to print on row
                        \     YC, so we add YC * 320 bytes to get to the correct
                        \     character row
                        \
                        \   * Because the game screen is 256 pixels wide and the
                        \     Commodore 64 screen is 320 pixels wide, we have a
                        \     32-pixel margin on each side that we need to skip
                        \     past, and 32 pixels is the width of four character
                        \     blocks, each of which takes up eight bytes of
                        \     bitmap memory, so we add another 4 * 8 = 32 bytes
                        \     to cater for the indent

ENDIF

IF NOT(_ELITE_A_6502SP_PARA OR _C64_VERSION)

.RREN

 STA SC+1               \ Store the page number of the destination screen
                        \ location in SC+1, so SC now points to the full screen
                        \ location where this character should go

ENDIF

IF _6502SP_VERSION \ Screen

 LDA SC                 \ Set (T S) = SC(1 0) + 8
 CLC                    \
 ADC #8                 \ starting with the low bytes
 STA S

 LDA SC+1               \ And then adding the high bytes, so (T S) points to the
 STA T                  \ character block after the one pointed to by SC(1 0),
                        \ and because T = S+1, we have:
                        \
                        \   S(1 0) = SC(1 0) + 8

ELIF _MASTER_VERSION

 LDA SC                 \ Set P(3 2) = SC(1 0) + 8
 CLC                    \
 ADC #8                 \ starting with the low bytes
 STA P+2

 LDA SC+1               \ And then adding the high bytes, so P(3 2) points to
 STA P+3                \ the character block after the one pointed to by
                        \ SC(1 0)

ELIF _C64_VERSION

 LDA XC                 \ Set SC(1 0) = SC(1 0) + XC * 8
 ASL A                  \
 ASL A                  \ So SC(1 0) now points to the screen address of the
 ASL A                  \ character block in column XC, which is where we want
 ADC SC                 \ to draw our character
 STA SC
 BCC P%+4
 INC SC+1

 CPY #127               \ If the character number (which is in Y) <> 127, then
 BNE RR2                \ skip to RR2 to print that character, otherwise this is
                        \ the delete character, so continue on

 DEC XC                 \ We want to delete the character to the left of the
                        \ text cursor and move the cursor back one, so let's
                        \ do that by decrementing YC. Note that this doesn't
                        \ have anything to do with the actual deletion below,
                        \ we're just updating the cursor so it's in the right
                        \ position following the deletion

 DEC SC+1               \ Decrement the high byte of the screen address to point
                        \ to the address of the current character, minus one
                        \ page

 LDY #&F8               \ Set Y = &F8, so the following call to ZESNEW will
                        \ count Y upwards from &F8 to &FF

 JSR ZESNEW             \ Call ZESNEW, which zero-fills from address SC(1 0) + Y
                        \ to SC(1 0) + &FF. SC(1 0) points to the character
                        \ above the text cursor, and adding &FF to this would
                        \ point to the cursor, so adding &F8 points to the
                        \ character before the cursor, which is the one we want
                        \ to delete. So this call zero-fills the character to
                        \ the left of the cursor, which erases it from the
                        \ screen

 BEQ RR4                \ We are done deleting, so restore the registers and
                        \ return from the subroutine (this BNE is effectively
                        \ a JMP as ZESNEW always returns with the Z flag set)

.RR2

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing
                        \ XC. Note that this doesn't have anything to do
                        \ with the actual printing below, we're just updating
                        \ the cursor so it's in the right position following
                        \ the print

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &85 &08, or BIT &0885, which does nothing apart
                        \ from affect the flags

 STA SC+1               \ This instruction has no effect, as it is always
                        \ skipped, so perhaps this was accidentally left behind
                        \ from development

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 LDY #7                 \ We want to print the 8 bytes of character data to the
                        \ screen (one byte per row), so set up a counter in Y
                        \ to count these bytes

.RRL1

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

 LDA (P+1),Y            \ The character definition is at P(2 1) - we set this up
                        \ above - so load the Y-th byte from P(2 1), which will
                        \ contain the bitmap for the Y-th row of the character

ELIF _6502SP_VERSION

                        \ We print the character's eight-pixel row in two parts,
                        \ starting with the first four pixels (one byte of
                        \ screen memory), and then the second four (a second
                        \ byte of screen memory)

 LDA (Q),Y              \ The character definition is at Q(1 0) - we set this up
                        \ above - so load the Y-th byte from Q(1 0), which will
                        \ contain the bitmap for the Y-th row of the character

 AND #%11110000         \ Extract the high nibble of the character definition
                        \ byte, so the first four pixels on this row of the
                        \ character are in the first nibble, i.e. xxxx 0000
                        \ where xxxx is the pattern of those four pixels in the
                        \ character

 STA U                  \ Set A = (A >> 4) OR A
 LSR A                  \
 LSR A                  \ which duplicates the high nibble into the low nibble
 LSR A                  \ to give xxxx xxxx
 LSR A
 ORA U

 AND COL                \ AND with the colour byte so that the pixels take on
                        \ the colour we want to draw (i.e. A is acting as a mask
                        \ on the colour byte)

ELIF _MASTER_VERSION

                        \ We print the character's eight-pixel row in two parts,
                        \ starting with the first four pixels (one byte of
                        \ screen memory), and then the second four (a second
                        \ byte of screen memory)

 LDA (P),Y              \ The character definition is at P(1 0) - we set this up
                        \ above - so load the Y-th byte from P(1 0), which will
                        \ contain the bitmap for the Y-th row of the character

 AND #%11110000         \ Extract the high nibble of the character definition
                        \ byte, so the first four pixels on this row of the
                        \ character are in the first nibble, i.e. xxxx 0000
                        \ where xxxx is the pattern of those four pixels in the
                        \ character

 STA W                  \ Set A = (A >> 4) OR A
 LSR A                  \
 LSR A                  \ which duplicates the high nibble into the low nibble
 LSR A                  \ to give xxxx xxxx
 LSR A
 ORA W

 AND COL                \ AND with the colour byte so that the pixels take on
                        \ the colour we want to draw (i.e. A is acting as a mask
                        \ on the colour byte)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _C64_VERSION OR _ELITE_A_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Platform: When we are docked in the disc version, we don't need to worry about displaying text on the space view, so we don't have to implement EOR logic when printing, and instead can use OR logic

 EOR (SC),Y             \ If we EOR this value with the existing screen
                        \ contents, then it's reversible (so reprinting the
                        \ same character in the same place will revert the
                        \ screen to what it looked like before we printed
                        \ anything); this means that printing a white pixel
                        \ onto a white background results in a black pixel, but
                        \ that's a small price to pay for easily erasable text

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 ORA (SC),Y             \ OR this value with the current contents of screen
                        \ memory, so the pixels we want to draw are set

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 STA (SC),Y             \ Store the Y-th byte at the screen address for this
                        \ character location

ENDIF

IF _6502SP_VERSION \ Screen

                        \ We now repeat the process for the second batch of four
                        \ pixels in this character row

 LDA (Q),Y              \ Fetch the bitmap for the Y-th row of the character
                        \ again

 AND #%00001111         \ This time we extract the low nibble of the character
                        \ definition, to get 0000 xxxx

 STA U                  \ Set A = (A << 4) OR A
 ASL A                  \
 ASL A                  \ which duplicates the low nibble into the high nibble
 ASL A                  \ to give xxxx xxxx
 ASL A
 ORA U

 AND COL                \ AND with the colour byte so that the pixels take on
                        \ the colour we want to draw (i.e. A is acting as a mask
                        \ on the colour byte)

 EOR (S),Y              \ EOR this value with the existing screen contents of
                        \ S(1 0), which is equal to SC(1 0) + 8, the next four
                        \ pixels along from the first four pixels we just
                        \ plotted in SC(1 0)

 STA (S),Y              \ Store the Y-th byte at the screen address for this
                        \ character location

ELIF _MASTER_VERSION

                        \ We now repeat the process for the second batch of four
                        \ pixels in this character row

 LDA (P),Y              \ Fetch the bitmap for the Y-th row of the character
                        \ again

 AND #%00001111         \ This time we extract the low nibble of the character
                        \ definition, to get 0000 xxxx

 STA W                  \ Set A = (A << 4) OR A
 ASL A                  \
 ASL A                  \ which duplicates the low nibble into the high nibble
 ASL A                  \ to give xxxx xxxx
 ASL A
 ORA W

 AND COL                \ AND with the colour byte so that the pixels take on
                        \ the colour we want to draw (i.e. A is acting as a mask
                        \ on the colour byte)

 EOR (P+2),Y            \ EOR this value with the existing screen contents of
                        \ P(3 2), which is equal to SC(1 0) + 8, the next four
                        \ pixels along from the first four pixels we just
                        \ plotted in SC(1 0)

 STA (P+2),Y            \ Store the Y-th byte at the screen address for this
                        \ character location

ENDIF

IF NOT(_ELITE_A_6502SP_PARA)

 DEY                    \ Decrement the loop counter

 BPL RRL1               \ Loop back for the next byte to print to the screen

ENDIF

IF _C64_VERSION

 LDY YC                 \ Set SC(1 0) to the address of the start of the current
 LDA celllookl,Y        \ text row in screen RAM, by looking up the address from
 STA SC                 \ the celllookl and celllookh tables for the row given
 LDA celllookh,Y        \ in YC
 STA SC+1               \
                        \ In the text view, screen RAM is used to determine the
                        \ colour of each on-screen character, so SC(1 0) is now
                        \ set to the address of the colour information for the
                        \ start of the current text row

 LDY XC                 \ Set the contents of SC(1 0) + XC to COL2
 LDA COL2               \
 STA (SC),Y             \ This sets the XC-th byte in SC(1 0) to COL2, which
                        \ sets the colour information for the XC-th character in
                        \ the current text row to COL2 - in other words, this
                        \ sets the colour of the character we just drew to COL2

ENDIF

.RR4

IF _ELITE_A_DOCKED

IF _BUG_FIX

 JSR SwitchToFileSys    \ Switch &C000 back to the filing system workspace

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Minor

 LDY YSAV2              \ We're done printing, so restore the values of the
 LDX XSAV2              \ A, X and Y registers that we saved above and clear
 LDA K3                 \ the C flag, so everything is back to how it was
 CLC

ELIF _6502SP_VERSION

 PLA                    \ We're done printing, so restore the values of the
 TAX                    \ A, X and Y registers that we saved above, so
 PLA                    \ everything is back to how it was
 TAY
 LDA K3

ELIF _MASTER_VERSION

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 PLX                    \ We're done printing, so restore the values of the
 PLY                    \ A, X and Y registers that we saved above and clear the
 LDA K3                 \ C flag, so everything is back to how it was
 CLC

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Label

.rT9

ENDIF

 RTS                    \ Return from the subroutine

IF NOT(_C64_VERSION)

.R5

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

ELIF _6502SP_VERSION

 LDX #LO(BELI)          \ Set (Y X) to point to the parameter block below
 LDY #HI(BELI)

 JSR OSWORD             \ We call this from above with A = 7, so this calls
                        \ OSWORD 7 to make a short, high beep

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

.BELI

 EQUW &0012             \ The SOUND block for a short, high beep:
 EQUW &FFF1             \
 EQUW &00C8             \   SOUND &12, -15, &C8, &02
 EQUW &0002             \
                        \ This makes a sound with flush control 1 on channel 2,
                        \ and with amplitude &F1 (-15), pitch &C8 (200) and
                        \ duration &02 (2). This is a louder, higher and longer
                        \ beep than that generated by the NOISE routine with
                        \ A = 32 (a short, high beep)

ENDIF

