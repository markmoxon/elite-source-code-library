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
                        \ for the Y-th character on row YC, to the pattern
                        \ number for our character from the loaded font

 STA (SC2),Y            \ Set the Y-th nametable entry in nametable buffer 1
                        \ for the Y-th character on row YC, to the pattern
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

