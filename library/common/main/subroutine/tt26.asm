\ ******************************************************************************
\
\       Name: TT26
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor (WRCHV points here)
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
\ WRCHV is set to point here by elite-loader.asm.
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 7 (beep)
\
\                         * 10-13 (line feeds and carriage returns)
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
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\   Y                   Y is preserved
\
\   C flag              The C flag is cleared
\
\ Other entry points:
\
\   RR3+1               Contains an RTS
\
\   RREN                Prints the character definition pointed to by P(2 1) at
\                       the screen address pointed to by (A SC). Used by the
\                       BULB routine
\
\   rT9                 Contains an RTS
\
\ ******************************************************************************

.TT26

IF _CASSETTE_VERSION

 STA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ RR4                \ RR4, which doesn't print anything, it just restores
                        \ the registers and returns from the subroutine

 CMP #7                 \ If this is a beep character (A = 7), jump to R5,
 BEQ R5                 \ which will emit the beep, restore the registers and
                        \ return from the subroutine

ELIF _6502SP_VERSION

 STA K3
 TYA
 PHA
 TXA
 PHA
 LDA K3
 TAY
 BEQ RR4S
 CMP #11
 BEQ cls
 CMP #7
 BNE P%+5
 JMP R5

ENDIF

 CMP #32                \ If this is an ASCII character (A >= 32), jump to RR1
 BCS RR1                \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ RRX1               \ RRX1, which will move down a line, restore the
                        \ registers and return from the subroutine

 LDX #1                 \ If we get here, then this is control code 11-13, of
 STX XC                 \ which only 13 is used. This code prints a newline,
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

.RRX1

IF _CASSETTE_VERSION

 INC YC                 \ Print a line feed, simply by incrementing the row
                        \ number (y-coordinate) of the text cursor, which is
                        \ stored in YC

 BNE RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine (this BNE is effectively a JMP as Y
                        \ will never be zero)

ELIF _6502SP_VERSION

 CMP #13
 BEQ RR4S
 INC YC

.RR4S

 JMP RR4

ENDIF

.RR1

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95. The quickest way
                        \ to display text on-screen is to poke the character
                        \ pixel by pixel, directly into screen memory, so
                        \ that's what the rest of this routine does
                        \
                        \ The first step, then, is to get hold of the bitmap
                        \ definition for the character we want to draw on the
                        \ screen (i.e. we need the pixel shape of this
                        \ character). The OS ROM contains bitmap definitions
                        \ of the BBC's ASCII characters, starting from &C000
                        \ for space (ASCII 32) and ending with the £ symbol
                        \ (ASCII 126)
                        \
                        \ There are 32 characters' definitions in each page of
                        \ memory, as each definition takes up 8 bytes (8 rows
                        \ of 8 pixels) and 32 * 8 = 256 bytes = 1 page. So:
                        \
                        \   ASCII 32-63  are defined in &C000-&C0FF (page &C0)
                        \   ASCII 64-95  are defined in &C100-&C1FF (page &C1)
                        \   ASCII 96-126 are defined in &C200-&C2F0 (page &C2)
                        \
                        \ The following code reads the relevant character
                        \ bitmap from the above locations in ROM and pokes
                        \ those values into the correct position in screen
                        \ memory, thus printing the character on-screen
                        \
                        \ It's a long way from 10 PRINT "Hello world!":GOTO 10

\LDX #LO(K3)            \ These instructions are commented out in the original
\INX                    \ source, but they call OSWORD &A, which reads the
\STX P+1                \ character bitmap for the character number in K3 and
\DEX                    \ stores it in the block at K3+1, while also setting
\LDY #HI(K3)            \ P+1 to point to the character definition. This is
\STY P+2                \ exactly what the following uncommented code does,
\LDA #10                \ just without calling OSWORD. Presumably the code
\JSR OSWORD             \ below is faster than using the system call, as this
                        \ version takes up 15 bytes, while the version below
                        \ (which ends with STA P+1 and SYX P+2) is 17 bytes.
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

 TAY                    \ Copy the character number from A to Y, as we are
                        \ about to pull A apart to work out where this
                        \ character definition lives in the ROM

                        \ Now we want to set X to point to the relevant page
                        \ number for this character - i.e. &C0, &C1 or &C2.
                        \ The following logic is easier to follow if we look
                        \ at the three character number ranges in binary:
                        \
                        \   Bit #  76543210
                        \
                        \   32  = %00100000     Page &C0
                        \   63  = %00111111
                        \
                        \   64  = %01000000     Page &C1
                        \   95  = %01011111
                        \
                        \   96  = %01100000     Page &C2
                        \   125 = %01111101
                        \
                        \ We'll refer to this below

IF _CASSETTE_VERSION

 LDX #&BF               \ Set X to point to the first font page in ROM minus 1,
                        \ which is &C0 - 1, or &BF

ELIF _6502SP_VERSION

 BPL P%+5
 JMP RR4
 LDX #(FONT%-1)

ENDIF

 ASL A                  \ If bit 6 of the character is clear (A is 32-63)
 ASL A                  \ then skip the following instruction
 BCC P%+4

IF _CASSETTE_VERSION

 LDX #&C1               \ A is 64-126, so set X to point to page &C1

ELIF _6502SP_VERSION

 LDX #(FONT%+1)

ENDIF

 ASL A                  \ If bit 5 of the character is clear (A is 64-95)
 BCC P%+3               \ then skip the following instruction

 INX                    \ Increment X
                        \
                        \ By this point, we started with X = &BF, and then
                        \ we did the following:
                        \
                        \   If A = 32-63:   skip    then INX  so X = &C0
                        \   If A = 64-95:   X = &C1 then skip so X = &C1
                        \   If A = 96-126:  X = &C1 then INX  so X = &C2
                        \
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

IF _CASSETTE_VERSION

 STA P+1                \ Store the address of this character's definition in
 STX P+2                \ P(2 1)

 LDA XC                 \ Fetch XC, the x-coordinate (column) of the text cursor
                        \ into A

ELIF _6502SP_VERSION

 STA Q
 STX R
 LDA XC
 LDX CATF
 BEQ RR5
 CPY #32
 BNE RR5
 CMP #17
 BEQ RR4

.RR5

ENDIF

 ASL A                  \ Multiply A by 8, and store in SC. As each
 ASL A                  \ character is 8 bits wide, and the special screen mode
 ASL A                  \ Elite uses for the top part of the screen is 256
 STA SC                 \ bits across with one bit per pixel, this value is
                        \ not only the screen address offset of the text cursor
                        \ from the left side of the screen, it's also the least
                        \ significant byte of the screen address where we want
                        \ to print this character, as each row of on-screen
                        \ pixels corresponds to one page. To put this more
                        \ explicitly, the screen starts at &6000, so the
                        \ text rows are stored in screen memory like this:
                        \
                        \   Row 1: &6000 - &60FF    YC = 1, XC = 0 to 31
                        \   Row 2: &6100 - &61FF    YC = 2, XC = 0 to 31
                        \   Row 3: &6200 - &62FF    YC = 3, XC = 0 to 31
                        \
                        \ and so on

 LDA YC                 \ Fetch YC, the y-coordinate (row) of the text cursor

 CPY #127               \ If the character number (which is in Y) <> 127, then
 BNE RR2                \ skip to RR2 to print that character, otherwise this is
                        \ the delete character, so continue on

 DEC XC                 \ We want to delete the character to the left of the
                        \ text cursor and move the cursor back one, so let's
                        \ do that by decrementing YC. Note that this doesn't
                        \ have anything to do with the actual deletion below,
                        \ we're just updating the cursor so it's in the right
                        \ position following the deletion

IF _CASSETTE_VERSION

 ADC #&5E               \ A contains YC (from above) and the C flag is set (from
 TAX                    \ the CPY #127 above), so these instructions do this:
                        \
                        \   X = YC + &5E + 1
                        \     = YC + &5F

ELIF _6502SP_VERSION

 ASL A
 ASL SC
 ADC #&3F
 TAX

ENDIF

                        \ Because YC starts at 0 for the first text row, this
                        \ means that X will be &5F for row 0, &60 for row 1 and
                        \ so on. In other words, X is now set to the page number
                        \ for the row before the one containing the text cursor,
                        \ and given that we set SC above to point to the offset
                        \ in memory of the text cursor within the row's page,
                        \ this means that (X SC) now points to the character
                        \ above the text cursor

IF _CASSETTE_VERSION

 LDY #&F8               \ Set Y = &F8, so the following call to ZES2 will count
                        \ Y upwards from &F8 to &FF

ELIF _6502SP_VERSION

 LDY #&F0

ENDIF

 JSR ZES2               \ Call ZES2, which zero-fills from address (X SC) + Y to
                        \ (X SC) + &FF. (X SC) points to the character above the
                        \ text cursor, and adding &FF to this would point to the
                        \ cursor, so adding &F8 points to the character before
                        \ the cursor, which is the one we want to delete. So
                        \ this call zero-fills the character to the left of the
                        \ cursor, which erases it from the screen

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

\LDA YC                 \ This instruction is commented out in the original
                        \ source. It isn't required because we only just did a
                        \ LDA YC before jumping to RR2, so this is presumably
                        \ an example of the authors squeezing the code to save
                        \ 2 bytes and 3 cycles
                        \
                        \ If you want to re-enable the commented block near the
                        \ start of this routine, you should uncomment this
                        \ instruction as well

 CMP #24                \ If the text cursor is on the screen (i.e. YC < 24, so
 BCC RR3                \ we are on rows 1-23), then jump to RR3 to print the
                        \ character

IF _6502SP_VERSION

 PHA

ENDIF

 JSR TTX66              \ Otherwise we are off the bottom of the screen, so
                        \ clear the screen and draw a white border

IF _6502SP_VERSION

 LDA #1
 STA XC
 STA YC
 PLA
 LDA K3

ENDIF

 JMP RR4                \ And restore the registers and return from the
                        \ subroutine

.RR3

IF _CASSETTE_VERSION

 ORA #&60               \ A contains the value of YC - the screen row where we
                        \ want to print this character - so now we need to
                        \ convert this into a screen address, so we can poke
                        \ the character data to the right place in screen
                        \ memory. We already stored the least significant byte
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

ELIF _6502SP_VERSION

 ASL A
 ASL SC
 ADC #&40

ENDIF

.RREN

 STA SC+1               \ Store the page number of the destination screen
                        \ location in SC+1, so SC now points to the full screen
                        \ location where this character should go

IF _6502SP_VERSION

 LDA SC
 CLC
 ADC #8
 STA S
 LDA SC+1
 STA T

ENDIF

 LDY #7                 \ We want to print the 8 bytes of character data to the
                        \ screen (one byte per row), so set up a counter in Y
                        \ to count these bytes

.RRL1

IF _CASSETTE_VERSION

 LDA (P+1),Y            \ The character definition is at P(2 1) - we set this up
                        \ above -  so load the Y-th byte from P(2 1)

ELIF _6502SP_VERSION

 LDA (Q),Y
 AND #&F0
 STA U
 LSR A
 LSR A
 LSR A
 LSR A
 ORA U
 AND COL

ENDIF

 EOR (SC),Y             \ If we EOR this value with the existing screen
                        \ contents, then it's reversible (so reprinting the
                        \ same character in the same place will revert the
                        \ screen to what it looked like before we printed
                        \ anything); this means that printing a white pixel on
                        \ onto a white background results in a black pixel, but
                        \ that's a small price to pay for easily erasable text

 STA (SC),Y             \ Store the Y-th byte at the screen address for this
                        \ character location

IF _6502SP_VERSION

 LDA (Q),Y
 AND #&F
 STA U
 ASL A
 ASL A
 ASL A
 ASL A
 ORA U
 AND COL
 EOR (S),Y
 STA (S),Y

ENDIF

 DEY                    \ Decrement the loop counter

 BPL RRL1               \ Loop back for the next byte to print to the screen

.RR4

IF _CASSETTE_VERSION

 LDY YSAV2              \ We're done printing, so restore the values of the
 LDX XSAV2              \ A, X and Y registers that we saved above and clear
 LDA K3                 \ the C flag, so everything is back to how it was
 CLC

ELIF _6502SP_VERSION

 PLA
 TAX
 PLA
 TAY
 LDA K3

ENDIF

.rT9

 RTS                    \ Return from the subroutine

.R5

IF _CASSETTE_VERSION

 JSR BEEP               \ Call the BEEP subroutine to make a short, high beep

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call

ELIF _6502SP_VERSION

 LDX #(BELI MOD256)
 LDY #(BELI DIV256)
 JSR OSWORD
 JMP RR4

.BELI

 EQUW &12
 EQUW &FFF1
 EQUW 200
 EQUW 2

ENDIF

