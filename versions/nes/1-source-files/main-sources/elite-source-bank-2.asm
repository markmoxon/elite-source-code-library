\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 2)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * bank2.bin
\
\ ******************************************************************************

 _BANK = 2

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

\ ******************************************************************************
\
\ ELITE BANK 2
\
\ Produces the binary file bank2.bin.
\
\ ******************************************************************************

 CODE% = &8000
 LOAD% = &8000

 ORG CODE%

INCLUDE "library/nes/main/subroutine/resetmmc1.asm"
INCLUDE "library/nes/main/subroutine/interrupts.asm"
INCLUDE "library/nes/main/variable/version_number.asm"
INCLUDE "library/enhanced/main/variable/tkn1.asm"
INCLUDE "library/enhanced/main/variable/rupla.asm"
INCLUDE "library/enhanced/main/variable/rugal.asm"
INCLUDE "library/enhanced/main/variable/rutok.asm"
INCLUDE "library/nes/main/variable/tkn1_de.asm"
INCLUDE "library/nes/main/variable/rupla_de.asm"
INCLUDE "library/nes/main/variable/rugal_de.asm"
INCLUDE "library/nes/main/variable/rutok_de.asm"
INCLUDE "library/nes/main/variable/tkn1_fr.asm"
INCLUDE "library/nes/main/variable/rupla_fr.asm"
INCLUDE "library/nes/main/variable/rugal_fr.asm"
INCLUDE "library/nes/main/variable/rutok_fr.asm"
INCLUDE "library/common/main/variable/qq18.asm"
INCLUDE "library/nes/main/variable/qq18_de.asm"
INCLUDE "library/nes/main/variable/qq18_fr.asm"
INCLUDE "library/nes/main/variable/rutok_lo.asm"
INCLUDE "library/nes/main/variable/rutok_hi.asm"
INCLUDE "library/enhanced/main/subroutine/detok3.asm"
INCLUDE "library/enhanced/main/subroutine/detok.asm"
INCLUDE "library/enhanced/main/subroutine/detok2.asm"
INCLUDE "library/enhanced/main/variable/jmtb.asm"
INCLUDE "library/enhanced/main/variable/mtin.asm"
INCLUDE "library/enhanced/main/subroutine/mt27.asm"
INCLUDE "library/enhanced/main/subroutine/mt28.asm"
INCLUDE "library/enhanced/main/subroutine/mt1.asm"
INCLUDE "library/enhanced/main/subroutine/mt2.asm"
INCLUDE "library/enhanced/main/subroutine/mt8.asm"
INCLUDE "library/enhanced/main/subroutine/mt16.asm"
INCLUDE "library/master/main/subroutine/filepr.asm"
INCLUDE "library/master/main/subroutine/otherfilepr.asm"
INCLUDE "library/enhanced/main/subroutine/mt9.asm"
INCLUDE "library/enhanced/main/subroutine/mt6.asm"
INCLUDE "library/enhanced/main/subroutine/mt5.asm"
INCLUDE "library/enhanced/main/subroutine/mt14.asm"
INCLUDE "library/enhanced/main/subroutine/mt15.asm"
INCLUDE "library/enhanced/main/subroutine/mt17.asm"
INCLUDE "library/enhanced/main/subroutine/mt18.asm"
INCLUDE "library/enhanced/main/subroutine/mt26.asm"
INCLUDE "library/enhanced/main/subroutine/mt19.asm"
INCLUDE "library/enhanced/main/subroutine/vowel.asm"
INCLUDE "library/enhanced/main/variable/tkn2.asm"
INCLUDE "library/common/main/variable/qq16.asm"
INCLUDE "library/enhanced/main/subroutine/bris.asm"
INCLUDE "library/enhanced/main/subroutine/pause.asm"
INCLUDE "library/enhanced/main/subroutine/mt23.asm"
INCLUDE "library/enhanced/main/subroutine/mt29.asm"
INCLUDE "library/enhanced/main/subroutine/mt13.asm"
INCLUDE "library/enhanced/main/subroutine/pause2.asm"
INCLUDE "library/nes/main/variable/rupla_lo.asm"
INCLUDE "library/nes/main/variable/rupla_hi.asm"
INCLUDE "library/nes/main/variable/rugal_lo.asm"
INCLUDE "library/nes/main/variable/rugal_hi.asm"
INCLUDE "library/nes/main/variable/nru.asm"
INCLUDE "library/enhanced/main/subroutine/pdesc.asm"
INCLUDE "library/common/main/subroutine/tt27.asm"
INCLUDE "library/common/main/subroutine/tt42.asm"
INCLUDE "library/common/main/subroutine/tt41.asm"
INCLUDE "library/common/main/subroutine/qw.asm"
INCLUDE "library/common/main/subroutine/tt45.asm"
INCLUDE "library/common/main/subroutine/tt43.asm"
INCLUDE "library/common/main/subroutine/ex.asm"
INCLUDE "library/enhanced/main/subroutine/tt26.asm"
INCLUDE "library/common/main/subroutine/bell.asm"

\ ******************************************************************************
\
\       Name: CHPR (Part 1 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character at the text cursor by poking into screen memory
\
\ ------------------------------------------------------------------------------
\
\ Print a character at the text cursor (XC, YC), do a beep, print a newline,
\ or delete left (backspace).
\
\ If the relevant font is already loaded into the pattern buffers, then this is
\ used as the tile pattern for the character, otherwise the pattern for the
\ character being printed is extracted from the fontImage table and into the
\ pattern buffer.
\
\ For fontStyle = 3, the pattern is always extracted from the fontImage table,
\ as it has different colour text (colour 3) than the normal font. This is used
\ when printing characters into 2x2 attribute blocks where printing the normal
\ font would result in the wrong colour text being shown.
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
\   fontStyle           Determines the font style:
\
\                         * 1 = normal font
\
\                         * 2 = highlight font
\
\                         * 3 = green text on a black background (colour 3 on
\                               background colour 0)
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
\ ******************************************************************************

.chpr1

 JMP chpr17             \ Jump to chpr17 to restore the registers and return
                        \ from the subroutine

.chpr2

 LDA #2                 \ Move the text cursor to row 2
 STA YC

 LDA K3                 \ Set A to the character to be printed

 JMP chpr4              \ Jump to chpr4 to print the character in A

.chpr3

 JMP chpr17             \ Jump to chpr17 to restore the registers and return
                        \ from the subroutine

 LDA #12                \ This instruction is never called, but it would set A
                        \ to a carriage return character and fall through into
                        \ CHPR to print the newline

.CHPR

 STA K3                 \ Store the A register in K3 so we can retrieve it below
                        \ (so K3 contains the number of the character to print)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3                 \ Store the A, X and Y registers, so we can restore
 STY YSAV2              \ them at the end (so they don't get changed by this
 STX XSAV2              \ routine)

 LDY QQ17               \ Load the QQ17 flag, which contains the text printing
                        \ flags

 CPY #255               \ If QQ17 = 255 then printing is disabled, so jump to
 BEQ chpr3              \ chpr17 (via the JMP in chpr3) to restore the registers
                        \ and return from the subroutine using a tail call

.chpr4

 CMP #7                 \ If this is a beep character (A = 7), jump to chpr1,
 BEQ chpr1              \ which will emit the beep, restore the registers and
                        \ return from the subroutine

 CMP #32                \ If this is an ASCII character (A >= 32), jump to chpr6
 BCS chpr6              \ below, which will print the character, restore the
                        \ registers and return from the subroutine

 CMP #10                \ If this is control code 10 (line feed) then jump to
 BEQ chpr5              \ chpr5, which will move down a line, restore the
                        \ registers and return from the subroutine

 LDX #1                 \ If we get here, then this is control code 11-13, of
 STX XC                 \ which only 13 is used. This code prints a newline,
                        \ which we can achieve by moving the text cursor
                        \ to the start of the line (carriage return) and down
                        \ one line (line feed). These two lines do the first
                        \ bit by setting XC = 1, and we then fall through into
                        \ the line feed routine that's used by control code 10

.chpr5

 CMP #13                \ If this is control code 13 (carriage return) then jump
 BEQ chpr3              \ to chpr17 (via the JMP in chpr3) to restore the
                        \ registers and return from the subroutine using a tail
                        \ call

 INC YC                 \ Increment the text cursor y-coordinate to move it
                        \ down one row

 BNE chpr3              \ Jump to chpr17 via chpr3 to restore the registers and
                        \ return from the subroutine using a tail call (this BNE
                        \ is effectively a JMP as Y will never be zero)

.chpr6

                        \ If we get here, then the character to print is an
                        \ ASCII character in the range 32-95

 LDX XC                 \ If the text cursor is on a column of 30 or less, then
 CPX #31                \ we have space to print the character on the current
 BCC chpr7              \ row, so jump to chpr7 to skip the following

 LDX #1                 \ The text cursor has moved off the right end of the
 STX XC                 \ current line, so move the cursor back to column 1 and
 INC YC                 \ down to the next row

.chpr7

 LDX YC                 \ If the text cursor is on row 26 or less, then the
 CPX #27                \ cursor is on-screen, so jump to chpr8 to skip the
 BCC chpr8              \ following instruction

 JMP chpr2              \ The cursor is off the bottom of the screen, so jump to
                        \ chpr2 to move the cursor up to row 2 before printing
                        \ the character

.chpr8

 CMP #127               \ If the character to print is not ASCII 127, then jump
 BNE chpr9              \ to chpr9 to skip the following instruction

 JMP chpr21             \ Jump to chpr21 to delete the character to the left of
                        \ the text cursor

\ ******************************************************************************
\
\       Name: CHPR (Part 2 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Jump to the right part of the routine depending on whether the
\             font pattern we need is already loaded
\
\ ******************************************************************************

.chpr9

 INC XC                 \ Once we print the character, we want to move the text
                        \ cursor to the right, so we do this by incrementing
                        \ XC. Note that this doesn't have anything to do
                        \ with the actual printing below, we're just updating
                        \ the cursor so it's in the right position following
                        \ the print

                        \ Before printing, we need to work out whether the font
                        \ we need is already loaded into the pattern buffers,
                        \ which will depend on the view type

 LDA QQ11               \ If bits 4 and 5 of the view type are clear, then no
 AND #%00110000         \ fonts are loaded, so jump to chpr11 to print the
 BEQ chpr11             \ character by copying the relevant font pattern into
                        \ the pattern buffers

                        \ If we get here then we know that at least one of bits
                        \ 4 and 5 is set in QQ11, which means the normal font is
                        \ loaded

 LDY fontStyle          \ If fontStyle = 1, then we want to print text using the
 CPY #1                 \ normal font, so jump to chpr10 to use the normal font
 BEQ chpr10             \ in the pattern buffers, as we know the normal font is
                        \ loaded

                        \ If we get here we know that fontStyle is 2 or 3

 AND #%00100000         \ If bit 5 of the view type in QQ11 is clear, then the
 BEQ chpr11             \ highlight font is not loaded, so jump to chpr11 to
                        \ print the character by copying the relevant font
                        \ pattern into the pattern buffers

                        \ If we get here then bit 5 of the view type in QQ11
                        \ is set, so we know that both the normal and highlight
                        \ fonts are loaded
                        \
                        \ We also know that fontStyle = 2 or 3

 CPY #2                 \ If fontStyle = 3, then we want to print the character
 BNE chpr11             \ in green text on a black background (so we can't use
                        \ the normal font as that's in colour 1 on black and we
                        \ need to print in colour 3 on black), so jump to chpr11
                        \ to print the character by copying the relevant font
                        \ pattern into the pattern buffers

                        \ If we get here then fontStyle = 2, so we want to print
                        \ text using the highlight font and we know it is
                        \ loaded, so we can go ahead and use the loaded font for
                        \ our character

 LDA K3                 \ Set A to the character to be printed

 CLC                    \ Set A = A + 95
 ADC #95                \
                        \ The highlight font is loaded into pattern 161, which
                        \ is 95 more than the normal font at pattern 66, so this
                        \ points A to the correct character number in the
                        \ highlight font

 JMP chpr22             \ Jump to chpr22 to print the character using a font
                        \ that has already been loaded

.chpr10

                        \ If we get here then fontStyle = 1 and the highlight
                        \ font is loaded, so we can use that for our character

 LDA K3                 \ Set A to the character to be printed

 JMP chpr22             \ Jump to chpr22 to print the character using a font
                        \ that has already been loaded

\ ******************************************************************************
\
\       Name: CHPR (Part 3 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Draw a character into the pattern buffers to show the character
\             on-screen
\
\ ******************************************************************************

.chpr11

                        \ If we get here then at least one of these is true:
                        \
                        \   * No font is loaded
                        \
                        \   * fontStyle = 2 (so we want to print highlighted
                        \     text) but the highlight font is not loaded
                        \
                        \   * fontStyle = 3 (so we want to print text in colour
                        \     3 on background colour 0)
                        \
                        \ In all cases, we need to draw the pattern for the
                        \ character directly into the relevant pattern buffer,
                        \ as it isn't already available in a loaded font

 LDA K3                 \ If the character to print in K3 is not a space, jump
 CMP #' '               \ to chpr12 to skip the following instruction
 BNE chpr12

 JMP chpr17             \ We are printing a space, so jump to chpr17 to return
                        \ from the subroutine

.chpr12

 TAY                    \ Set Y to the character to print
                        \
                        \ Let's call the character number chr

                        \ We now want to calculate the address of the pattern
                        \ data for this character in the fontImage table, which
                        \ contains the font images in ASCII order, starting from
                        \ the space character (which maps to ASCII 32)
                        \
                        \ There are eight bytes in each character's pattern, so
                        \ the address we are after is therefore:
                        \
                        \   fontImage + (chr - 32) * 8
                        \
                        \ This calculation is optimised below to take advantage
                        \ of the fact that LO(fontImage) = &E8 = 29 * 8, so:
                        \
                        \   fontImage + (chr - 32) * 8
                        \ = HI(fontImage) * 256 + LO(fontImage) + (chr - 32) * 8
                        \ = HI(fontImage) * 256 + (29 * 8) + (chr - 32) * 8
                        \ = HI(fontImage) * 256 + (29 + chr - 32) * 8
                        \ = HI(fontImage) * 256 + (chr - 3) * 8
                        \
                        \ So that is what we calculate below

 CLC                    \ Set A = A - 3
 ADC #&FD               \       = chr - 3
                        \
                        \ This could also be done using SEC and SBC #3

 LDX #0                 \ Set P(2 1) = A * 8
 STX P+2                \            = (chr - 3) * 8
 ASL A                  \            = chr * 8 - 24
 ROL P+2
 ASL A
 ROL P+2
 ASL A
 ROL P+2
 ADC #0
 STA P+1

 LDA P+2                \ Set P(2 1) = P(2 1) + HI(fontImage) * 256
 ADC #HI(fontImage)     \            = HI(fontImage) * 256 + (chr - 3) * 8
 STA P+2                \
                        \
                        \ So P(2 1) is the address of the pattern data for the
                        \ character that we want to print

 LDA #0                 \ Set SC+1 = 0 (though this is never used as SC+1 is
 STA SC+1               \ overwritten again before it is used)

 LDA YC                 \ If the text cursor is not on row 0, jump to chpr13 to
 BNE chpr13             \ skip the following instruction

 JMP chpr31             \ The text cursor is on row 0, so jump to chpr31 to set
                        \ SC(1 0) to the correct address in the nametable buffer
                        \ and return to chpr15 below to draw the character

.chpr13

 LDA QQ11               \ If this is not the space view (i.e. QQ11 is non-zero)
 BNE chpr14             \ then jump to chpr14 to skip the following instruction

 JMP chpr28             \ This is the space view with no fonts loaded, so jump
                        \ to chpr28 to draw the character on-screen, merging the
                        \ text with whatever is already there

.chpr14

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 LDA (SC),Y             \ This has no effect, as chpr15 is the next label and
 BEQ chpr15             \ neither A nor the status flags are read before being
                        \ overwritten, but it checks whether the nametable entry
                        \ for the character we want to draw is empty (and then
                        \ does nothing if it is)

.chpr15

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ chpr17             \ to use for drawing characters, so jump to chpr17 to
                        \ return from the subroutine without printing anything

 CMP #255               \ If firstFreeTile = 255 then we have run out of tiles
 BEQ chpr17             \ to use for drawing characters, so jump to chpr17 to
                        \ return from the subroutine without printing anything

 STA (SC),Y             \ Otherwise firstFreeTile contains the number of the
 STA (SC2),Y            \ next available tile for drawing, so allocate this
                        \ tile to cover the character that we want to draw by
                        \ setting the nametable entry in both buffers to the
                        \ tile number we just fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ tile for drawing, so it can be added to the nametable
                        \ the next time we need to draw into a tile

 LDY fontStyle          \ If fontStyle = 1, jump to chpr18
 DEY
 BEQ chpr18

 DEY                    \ If fontStyle = 3, jump to chpr16
 BNE chpr16

 JMP chpr19             \ Otherwise fontStyle = 2, so jump to chpr19

.chpr16

                        \ If we get here then fontStyle = 3 and we need to
                        \ copy the pattern data for this character from the
                        \ address in P(2 1) into both pattern buffers 0 and 1

 TAY                    \ Set Y to the character to print

 LDX #HI(pattBuffer0)/8 \ Set SC2(1 0) = (pattBuffer0/8 A) * 8
 STX SC2+1              \              = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC2+1              \ So SC2(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC2+1              \ pattern data), which means SC2(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC2+1              \ we are drawing in pattern buffer 0
 STA SC2

 TYA                    \ Set A back to the character to print

 LDX #HI(pattBuffer1)/8 \ Set SC(1 0) = (pattBuffer1/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing in pattern buffer 1
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer addresses
                        \ in SC(1 0) and SC2(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffers in SC(1 0) and SC2(1 0),
 STA (SC2),Y            \ and increment the byte counter in Y
 INY

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC2),Y            \ byte of the pattern buffers in SC(1 0) and SC2(1 0)
 STA (SC),Y

.chpr17

 LDY YSAV2              \ We're done printing, so restore the values of the
 LDX XSAV2              \ X and Y registers that we saved above

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA K3                 \ Restore the value of the A register that we saved
                        \ above

 CLC                    \ Clear the C flag, so everything is back to how it was

 RTS                    \ Return from the subroutine

.chpr18

                        \ If we get here then fontStyle = 1 and we need to
                        \ copy the pattern data for this character from the
                        \ address in P(2 1) into pattern buffer 0

 LDX #HI(pattBuffer0)/8 \ Set SC(1 0) = (pattBuffer0/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing in pattern buffer 0
 STA SC


 JMP chpr20             \ Jump to chpr20 to draw the pattern we need for our
                        \ text character into the pattern buffer

.chpr19

                        \ If we get here then fontStyle = 2 and we need to
                        \ copy the pattern data for this character from the
                        \ address in P(2 1) into pattern buffer 1

 LDX #HI(pattBuffer1)/8 \ Set SC(1 0) = (pattBuffer1/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing in pattern buffer 1
 STA SC

.chpr20

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0)

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

\ ******************************************************************************
\
\       Name: CHPR (Part 4 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Process the delete character
\
\ ******************************************************************************

.chpr21

                        \ If we get here then we are printing ASCII 127, which
                        \ is the delete character

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDY XC                 \ Set Y to the text column of the text cursor, which
                        \ points to the character we want to delete (as we are
                        \ printing a delete character there)

 DEC XC                 \ Decrement XC to move the text cursor left by one
                        \ place, as we are deleting a character

 LDA #0                 \ Zero the Y-th nametable entry in nametable buffer 0
 STA (SC),Y             \ for the Y-th character on row YC, which deletes the
                        \ character that was there

 STA (SC2),Y            \ Zero the Y-th nametable entry in nametable buffer 1
                        \ for the Y-th character on row YC, which deletes the
                        \ character that was there

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

\ ******************************************************************************
\
\       Name: CHPR (Part 5 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print the character using a font that has already been loaded
\
\ ******************************************************************************

.chpr22

                        \ If we get here then one of these is true:
                        \
                        \   * The normal and highlight fonts are loaded
                        \     fontStyle = 2
                        \     A = character number + 95
                        \
                        \   * The normal font is loaded
                        \     fontStyle = 1
                        \     A = character number

 PHA                    \ Store A on the stack to we can retrieve it after the
                        \ call to GetRowNameAddress

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 PLA                    \ Retrieve the character number we stored on the stack
                        \ above

 CMP #' '               \ If we are printing a space, jump to chpr25
 BEQ chpr25

.chpr23

 CLC                    \ Convert the ASCII number in A to the pattern number in
 ADC asciiToPattern     \ the PPU of the corresponding character image, by
                        \ adding asciiToPattern (which gets set when the view
                        \ is set up)

.chpr24

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 STA (SC),Y             \ Set the Y-th nametable entry in nametable buffer 0
                        \ for the Y-th character on row YC, to the tile pattern
                        \ number for our character from the loaded font

 STA (SC2),Y            \ Set the Y-th nametable entry in nametable buffer 1
                        \ for the Y-th character on row YC, to the tile pattern
                        \ number for our character from the loaded font

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr25

                        \ If we get here then we are printing a space

 LDY QQ11               \ If the view type in QQ11 is &9D (Long-range Chart with
 CPY #&9D               \ the normal font loaded), jump to chpr26 to use pattern
 BEQ chpr26             \ 0 as the space character

 CPY #&DF               \ If the view type in QQ11 is not &DF (Start screen with
 BNE chpr23             \ the normal font loaded), jump to chpr23 to convert
                        \ the ASCII number in A to the pattern number

.chpr26

 LDA #0                 \ This is either view &9D (Long-range Chart) or &DF
                        \ (Start screen), and in both these views the normal
                        \ font is loaded directly into the PPU at a different
                        \ pattern number to the other views, so we set A = 0 to
                        \ use as the space character, as that is always a blank
                        \ tile

 BEQ chpr24             \ Jump up to chpr24 to draw the character (this BEQ is
                        \ effectively a JMP as A is always zero)

\ ******************************************************************************
\
\       Name: CHPR (Part 6 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character in the space view when the relevant font is not
\             loaded, merging the text with whatever is already on-screen
\
\ ******************************************************************************

.chpr27

                        \ We jump here from below when the tile we are drawing
                        \ into is not empty

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0), using OR logic to merge the character with
                        \ the existing contents of the tile

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer, and
 INY                    \ increment the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 ORA (SC),Y             \ byte of the pattern buffer in SC(1 0), OR'ing the byte
 STA (SC),Y             \ with the existing contents of the pattern buffer

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr28

                        \ If we get here then this is the space view with no
                        \ font loaded, and we have set up P(2 1) to point to the
                        \ pattern data for the character we want to draw

 LDA #0                 \ Set SC+1 = 0 to act as the high byte of SC(1 0) in the
 STA SC+1               \ calculation below

 LDA YC                 \ Set A to the current text cursor row

 BNE chpr29             \ If the cursor is in row 0, set A = 255 so the value
 LDA #255               \ of A + 1 is 0 in the calculation below

.chpr29

 CLC                    \ Set (SC+1 A) = (A + 1) * 16
 ADC #1
 ASL A
 ASL A
 ASL A
 ASL A
 ROL SC+1

 SEC                    \ Set SC(1 0) = (nameBufferHi 0) + (SC+1 A) * 2 + 1
 ROL A                  \             = (nameBufferHi 0) + (A + 1) * 32 + 1
 STA SC                 \
 LDA SC+1               \ So SC(1 0) points to the entry in the nametable buffer
 ROL A                  \ for the start of the row below the text cursor, plus 1
 ADC nameBufferHi
 STA SC+1

 LDY XC                 \ Set Y to the column of the text cursor, minus one
 DEY

                        \ So SC(1 0) + Y now points to the nametable entry of
                        \ the tile where we want to draw our character

 LDA (SC),Y             \ If the nametable entry for the tile is not empty, then
 BNE chpr27             \ jump up to chpr27 to draw our character into the
                        \ existing pattern for this tile

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ chpr30             \ to use for drawing characters, so jump to chpr17 via
                        \ chpr30 to return from the subroutine without printing
                        \ anything

 STA (SC),Y             \ Otherwise firstFreeTile contains the number of the
                        \ next available tile for drawing, so allocate this
                        \ tile to cover the character that we want to draw by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ tile for drawing, so it can be added to the nametable
                        \ the next time we need to draw into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC+1               \ we are drawing
 STA SC

                        \ We now copy the pattern data for this character from
                        \ the address in P(2 1) to the pattern buffer address
                        \ in SC(1 0)

 LDY #0                 \ We want to copy eight bytes of pattern data, as each
                        \ character has eight rows of eight pixels, so set a
                        \ byte index counter in Y

                        \ We repeat the following code eight times, so it copies
                        \ one whole pattern of eight bytes

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0), and increment
 INY                    \ the byte counter in Y

 LDA (P+1),Y            \ Copy the Y-th pattern byte from P(2 1) to the Y-th
 STA (SC),Y             \ byte of the pattern buffer in SC(1 0)


.chpr30

 JMP chpr17             \ Jump to chpr17 to return from the subroutine, as we
                        \ are done printing this character

.chpr31

                        \ If we get here then this is the space view and the
                        \ text cursor is on row 0

 LDA #33                \ Set SC(1 0) to the address of tile 33 in the nametable
 STA SC                 \ buffer, which is the first tile on row 1
 LDA nameBufferHi
 STA SC+1

 LDY XC                 \ Set Y to the column of the text cursor - 1
 DEY

 JMP chpr15             \ Jump up to chpr15 to continue drawing the character

INCLUDE "library/nes/main/variable/lowercase.asm"
INCLUDE "library/nes/main/variable/vectors.asm"

\ ******************************************************************************
\
\ Save bank2.bin
\
\ ******************************************************************************

 PRINT "S.bank2.bin ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/nes/3-assembled-output/bank2.bin", CODE%, P%, LOAD%
