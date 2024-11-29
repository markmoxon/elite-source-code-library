\ ******************************************************************************
\
\       Name: PrintFlightMessage
\       Type: Subroutine
\   Category: Text
\    Summary: Print an in-flight message
\
\ ******************************************************************************

.PrintFlightMessage

 LDA messYC             \ Set A to the current row for in-flight messages

 LDX QQ11               \ If this is the space view, jump to fmes1 to skip the
 BEQ fmes1              \ following and leave A with this value, so we print the
                        \ in-flight message on the row specified in messYC

 JSR CLYNS+8            \ Clear the bottom two text rows of the visible screen,
                        \ and move the text cursor to the first cleared row, but
                        \ without resetting the in-flight message timer

 LDA #23                \ Set A to 23, so we print the in-flight message on row
                        \ 23 for all views other than the space view

.fmes1

 STA YC                 \ Move the text cursor to the row in A

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA messXC             \ Move the text cursor to column messXC, which we set
 STA XC                 \ to the text column of the current in-flight message
                        \ when we called MESS to display it

 LDA messXC             \ This appears to be an unnecessary duplicate of the
 STA XC                 \ above

 LDY #0                 \ We now work through the message one character at a
                        \ time, so set a character counter in Y

.fmes2

 LDA messageBuffer,Y    \ Fetch the Y-th character from the message buffer

 JSR CHPR_b2            \ Print the character

 INY                    \ Increment the character counter in Y

 CPY messageLength      \ Loop back until we have printed all the characters in
 BNE fmes2              \ the buffer, whose size is in messageLength

 LDA QQ11               \ If this is the space view, jump to RTS5 to return from
 BEQ RTS5               \ the subroutine, as the NMI handler will take care of
                        \ updating the screen when we next flip bitplanes

 JMP DrawMessageInNMI   \ Configure the NMI to display the message that we just
                        \ printed, returning from the subroutine using a tail
                        \ call

