\ ******************************************************************************
\
\       Name: CHPR (Part 3 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Draw a character into the pattern buffers to show the character
\             on-screen
\  Deep dive: Fonts in NES Elite
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

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ chpr17             \ patterns to use for drawing characters, so jump to
                        \ chpr17 to return from the subroutine without printing
                        \ anything

 CMP #255               \ If firstFreePattern = 255 then we have run out of
 BEQ chpr17             \ patterns to use for drawing characters, so jump to
                        \ chpr17 to return from the subroutine without printing
                        \ anything

 STA (SC),Y             \ Otherwise firstFreePattern contains the number of the
 STA (SC2),Y            \ next available pattern for drawing, so allocate this
                        \ pattern to cover the character that we want to draw by
                        \ setting the nametable entry in both buffers to the
                        \ pattern number we just fetched

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be added to
                        \ the nametable the next time we need to draw into a
                        \ pattern

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
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC2+1              \ pattern data), which means SC2(1 0) points to the
 ASL A                  \ pattern data for the tile containing the character
 ROL SC2+1              \ we are drawing in pattern buffer 0
 STA SC2

 TYA                    \ Set A back to the character to print

 LDX #HI(pattBuffer1)/8 \ Set SC(1 0) = (pattBuffer1/8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
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
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
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
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
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

