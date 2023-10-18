\ ******************************************************************************
\
\       Name: StoreMessage
\       Type: Subroutine
\   Category: Text
\    Summary: Copy a message from the justified text buffer at BUF into the
\             message buffer
\
\ ******************************************************************************

.StoreMessage

 LDA #32                \ Set A = 32 - DTW5
 SEC                    \
 SBC DTW5               \ Where DTW5 is the size of the justified text buffer at
                        \ BUF, so A contains the number of characters remaining
                        \ if we print the message buffer on one line (as each
                        \ line contains 32 characters)

 BCS smes1              \ If the subtraction didn't underflow, then the message
                        \ in the message buffer will fit on one line, so jump to
                        \ smes1 with the remaining number of characters in A

                        \ The subtraction underflowed, so the message will not
                        \ fit on one line
                        \
                        \ In this case we just print as many characters as we
                        \ can and truncate the message at the end of the line

 LDA #31                \ Set the size of the message buffer in DTW5 to 31,
 STA DTW5               \ which is the maximum size of a one-line message

 LDA #2                 \ Set A = 2 so the message will be printed in column 1
                        \ on the left of the screen

.smes1

                        \ When we get here, A contains the number of characters
                        \ remaining if we were to print the message on one line
                        \ of the screen

 LSR A                  \ Set A = A / 2
                        \
                        \ So A now contains half the amount of free space left
                        \ if we print the message on one line, which is the
                        \ amount of space on each side of the message when it is
                        \ centred on the line
                        \
                        \ In other words, this is the column number where we
                        \ need to print our message for it to be centred
                        \ on-screen

 STA messXC             \ Store A in messXC, so when we erase the message via
                        \ the branch to me1 above, messXC will tell us where to
                        \ print it

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX DTW5               \ Set the size of the message in the message buffer to
 STX messageLength      \ the size of the justified text buffer, as we are about
                        \ to copy from one to the other

 INX                    \ Set X as a character counter so we can loop through
                        \ message and copy it one character at a time (we
                        \ increment it so X is at least 1, to make the following
                        \ loop work)

.smes2

 LDA BUF-1,X            \ Copy the character number X - 1 from BUF into
 STA messageBuffer-1,X  \ messageBuffer

 DEX                    \ Decrement the character counter

 BNE smes2              \ Loop back until we have copied all X characters

 STX de                 \ Zero de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't append
                        \ it to the next message

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ Fall through into DisableJustifyText to reset DTW4 and
                        \ DTW5 to turn off justified text and reset the
                        \ justified text buffer

