\ ******************************************************************************
\
\       Name: LOGOS
\       Type: Subroutine
\   Category: Loader
\    Summary: Print a large Acornsoft logo as part of the loading screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   T                   The logo colour as a teletext control code for graphics
\                       colour
\
\   ZP(1 0)             The address of the Acornsoft logo character table at
\                       LOGO
\
\ ******************************************************************************

.LOGOS

 LDY #28                \ Set Y = 28 as an index to the first row of logo
                        \ characters in the table at LOGO, after the 28 bytes of
                        \ lookup data in the first part of the table

.aloop

 LDX #38                \ Each row of the Acornsoft logo consists of 38 teletext
                        \ graphics characters, so set a counter in X to count
                        \ through the characters

 BIT S                  \ If bit 7 of S is set (this is an Electron), jump to
 BMI eskip1             \ eskip1 to skip the teletext colour codes (as the
                        \ Electron loading screen is monochrome)

 LDA T                  \ Print the character in T, which starts with teletext
 JSR OSWRCH             \ control code 145 (Red graphics) and increments through
                        \ the colours, so this sets the correct colour for the
                        \ current Acornsoft logo

 LDA #154               \ Print teletext control code 154 (Separated graphics)
 JSR OSWRCH

 CLC                    \ Skip the next two instructions
 BCC P%+7

.eskip1

 LDA #' '               \ Print a space (on the Electron only)
 JSR OSWRCH

.cloop

 LDA (ZP),Y             \ Fetch the Y-th character from ZP into A, so A contains
                        \ the next byte from LOGO, which is the user-defined
                        \ character we want to print (in the case of the
                        \ Electron), or the index into the first section of the
                        \ LOGO table for the teletext graphics character we want
                        \ to print (in the case of the BBC Micro)

 BIT S                  \ If bit 7 of S is set (this is an Electron), jump to
 BMI eskip2             \ eskip2

 STY P                  \ Store Y so we can retrieve it below

 TAY                    \ This is a BBC Micro, so the number in A is the index
 LDA (ZP),Y             \ into the first section of the LOGO table for the
                        \ teletext graphics character we want to print, so we
                        \ now fetch that character

 LDY P                  \ Retrieve the value of Y we stored above

 BNE P%+4               \ Skip the next instruction (this BNE is effectively a
                        \ JMP as Y is never zero)

.eskip2

 ORA #&E0               \ Add &E0 to the character number (on the Electron only)

 JSR OSWRCH             \ Print the character in A

 INY                    \ Increment Y to point to the next byte in the table

 CPY #255               \ If Y = 255 then we are done printing all 5 rows of the
 BEQ adone              \ logo, so jump to adone to finish off

 DEX                    \ Otherwise decrement the character counter in X

 BNE cloop              \ Loop back to print the next character until we have
                        \ done all 38 in this row

 BIT S                  \ If bit 7 of S is clear (this is a BBC Micro), skip the
 BPL P%+7               \ next two instructions

 LDA #' '               \ Print a space (on the Electron only)
 JSR OSWRCH

 CLC                    \ Jump back to aloop to print the next row in the logo
 BCC aloop

.adone

 INC T                  \ Increment the colour in T, which started with teletext
                        \ control code 145 (Red graphics) and increments through
                        \ 146 (green), 147 (yellow) and 148 (blue) with each new
                        \ call to the LOGOS routine

 RTS                    \ Return from the subroutine

