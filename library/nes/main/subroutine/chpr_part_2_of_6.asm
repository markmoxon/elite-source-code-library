\ ******************************************************************************
\
\       Name: CHPR (Part 2 of 6)
\       Type: Subroutine
\   Category: Text
\    Summary: Jump to the right part of the routine depending on whether the
\             font pattern we need is already loaded
\  Deep dive: Fonts in NES Elite
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

