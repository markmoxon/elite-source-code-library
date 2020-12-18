\ ******************************************************************************
\
\       Name: ECBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Implement the #DOBULB 255 command (draw the E.C.M. indicator bulb)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOBULB 255 command. It draws
\ (or erases) the E.C.M. indicator bulb ("E") on the dashboard.
\
\ ******************************************************************************

.ECBLB

 LDA #8*14              \ The E.C.M. bulb is in character block number 14 with
 STA SC                 \ each character taking 8 bytes, so this sets the low
                        \ byte of the screen address of the character block we
                        \ want to draw to

 LDA #&7A               \ Set the high byte of SC(1 0) to &7A, as the bulbs are
 STA SC+1               \ both in the character row from &7A00 to &7BFF, and the
                        \ E.C.M. bulb is in the left half, which is from &7A00
                        \ to &7AFF

 LDY #15                \ Now to poke the bulb bitmap into screen memory, and
                        \ there are two character blocks' worth, each with eight
                        \ lines of one byte, so set a counter in Y for 16 bytes

.BULL2

 LDA ECBT,Y             \ Fetch the Y-th byte of the bulb bitmap

 EOR (SC),Y             \ EOR the byte with the current contents of screen
                        \ memory, so drawing the bulb when it is already
                        \ on-screen will erase it

 STA (SC),Y             \ Store the Y-th byte of the bulb bitmap in screen
                        \ memory

 DEY                    \ Decrement the loop counter

 BPL BULL2              \ Loop back to poke the next byte until we have done
                        \ all 16 bytes across two character blocks

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

