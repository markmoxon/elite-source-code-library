\ ******************************************************************************
\
\       Name: ClearNameInMiddle
\       Type: Subroutine
\   Category: Save and load
\    Summary: Remove the commander name from the middle column
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The slot number to clear in the middle column (0 to 7)
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.ClearNameInMiddle

 LDX #11                \ Move the text cursor to column 11, so we print the
 STX XC                 \ name in the middle column of the screen

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 ASL A                  \ Move the text cursor to row 6 + A * 2
 CLC                    \
 ADC #6                 \ So this is the text row for slot number A in the
 STA YC                 \ middle column of the screen

 JSR GetRowNameAddress  \ Get the addresses in the nametable buffers for the
                        \ start of character row YC, as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDA SC                 \ Set SC(1 0) = SC(1 0) + XC
 CLC                    \
 ADC XC                 \ So SC(1 0) is the address in nametable buffer 0 for
 STA SC                 \ the tile at cursor position (XC, YC)

 LDY #8                 \ We now want to print 8 spaces over the top of the slot
                        \ at (XC, YC), so set Y as a loop counter to count down
                        \ from 8

 LDA #0                 \ Set A = 0 to use as the pattern number for the blank
                        \ background tile

.cpos1

 STA (SC),Y             \ Set the Y-th tile of the slot in nametable buffer 0 to
                        \ the blank tile

 DEY                    \ Decrement the tile counter

 BPL cpos1              \ Loop back until we have blanked out every character
                        \ of the slot

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

