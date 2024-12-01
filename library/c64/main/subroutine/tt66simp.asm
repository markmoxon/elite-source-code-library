\ ******************************************************************************
\
\       Name: TT66simp
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the whole screen inside the border box, and move the text
\             cursor to the top-left corner
\
\ ******************************************************************************

.TT66simp

 LDX #8                 \ We are going to clear character rows 1 through 23,
                        \ so that's from pixel y-coordinate 8 onwards, so set a
                        \ set a pixel y-coordinate counter in X

 LDY #0                 \ Set Y = 0, so we can use it as a byte counter below

 CLC                    \ Clear the C flag so the addition below works

.T6SL1

 LDA ylookupl,X         \ Set SC(1 0) to the address in screen memory of the
 STA SC                 \ start of the character row within the game screen that
 LDA ylookuph,X         \ contains pixel y-coordinate Y
 STA SC+1

 TYA                    \ Set A = 0, which we can use to zero screen memory

                        \ We now zero a whole page of memory (256 bytes) at
                        \ SC(1 0), using Y as a byte counter, starting from
                        \ Y = 0

.T6SL2

 STA (SC),Y             \ Zero the Y-th byte of SC(1 0)

 DEY                    \ Decrement the byte counter

 BNE T6SL2              \ Loop back until we have zeroed a whole page of bytes
                        \ (which corresponds to an entire character row of width
                        \ 256 pixels, which is the width of the game screen)

 TXA                    \ Set X = X + 8
 ADC #8                 \
 TAX                    \ So X now points to the pixel coordinate at the start
                        \ of the next character row

 CMP #24*8              \ Loop back until we have cleared character rows 1
 BCC T6SL1              \ through 23 (i.e. values of X from 8 to 23*8)

 INY                    \ Move the text cursor to column 1
 STY XC

 STY YC                 \ Move the text cursor to row 1

 RTS                    \ Return from the subroutine

