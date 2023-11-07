\ ******************************************************************************
\
\       Name: DrawScrollFrames
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Draw a scroll text over multiple frames
\  Deep dive: The NES combat demo
\
\ ******************************************************************************

.DrawScrollFrames

 LDA controller1A       \ If the A button is being pressed on controller 1, jump
 BMI scfr1              \ to scfr1 to speed up the scroll text

 LDA iconBarChoice      \ If the fast-forward button has not been chosen on the
 CMP #12                \ icon bar, jump to scfr2 to leave the speed as it is
 BNE scfr2

 LDA #0                 \ Set iconBarChoice = 0 to clear the icon button choice
 STA iconBarChoice      \ so we don't process it again

.scfr1

                        \ If we get here then either the A button has been
                        \ pressed or the fast-forward button has been chosen on
                        \ the icon bar

 LDA #9                 \ Set the scroll text speed to 9 (fast)
 STA scrollTextSpeed

.scfr2

 JSR FlipDrawingPlane   \ Flip the drawing bitplane so we draw into the bitplane
                        \ that isn't visible on-screen

 JSR DrawScrollFrame    \ Draw one frame of the scroll text

 JSR DrawBitplaneInNMI  \ Configure the NMI to send the drawing bitplane to the
                        \ PPU after drawing the box edges and setting the next
                        \ free tile number

 LDA iconBarChoice      \ If no buttons have been pressed on the icon bar while
 BEQ scfr3              \ drawing the frame, jump to scfr3 to skip the following
                        \ instruction

 JSR CheckForPause_b0   \ If the Start button has been pressed then process the
                        \ pause menu and set the C flag, otherwise clear it

.scfr3

 LDA scrollProgress     \ Set scrollProgress = scrollProgress - scrollTextSpeed
 SEC                    \
 SBC scrollTextSpeed    \ So we update the scroll text progress
 STA scrollProgress

 BCS DrawScrollFrames   \ If the subtraction didn't underflow then the value of
                        \ scrollProgress is still positive and there is more
                        \ scrolling to be done, so loop back to the start of
                        \ the routine to keep going

 RTS                    \ Return from the subroutine

