\ ******************************************************************************
\
\       Name: TT17
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for cursor key or joystick movement
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard and joystick for cursor key or stick movement, and return
\ the result as deltas (changes) in x- and y-coordinates as follows:
\
\   * For joystick, X and Y are integers between -2 and +2 depending on how far
\     the stick has moved
\
\   * For keyboard, X and Y are integers between -1 and +1 depending on which
\     keys are pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The key pressed, if the arrow keys were used
\
\   X                   Change in the x-coordinate according to the cursor keys
\                       being pressed or joystick movement, as an integer (see
\                       above)
\
\   Y                   Change in the y-coordinate according to the cursor keys
\                       being pressed or joystick movement, as an integer (see
\                       above)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TJ1                 Check for cursor key presses and return the combined
\                       deltas for the digital joystick and cursor keys (Master
\                       Compact only)
\
\ ******************************************************************************

.TT17

 LDA QQ11               \ If this not the space view, skip the following three
 BNE TT17afterall       \ instructions to move onto the SHIFT key logic

 JSR DOKEY              \ This is the space view, so scan the keyboard for
                        \ flight controls and pause keys, (or the equivalent on
                        \ joystick) and update the key logger, setting KL to the
                        \ key pressed

 TXA                    \ Transfer the value of the key pressed from X to A

 RTS                    \ Return from the subroutine

.TT17afterall

 JSR DOKEY              \ Scan the keyboard for flight controls and pause keys,
                        \ (or the equivalent on joystick) and update the key
                        \ logger, setting KL to the key pressed

 LDA JSTK               \ If the joystick is not configured, jump down to TJ1,
 BEQ TJ1                \ otherwise we move the cursor with the joystick

 LDA KY3                \ ???
 BIT KY4
 BPL P%+4
 LDA #1
 BIT KY7
 BPL P%+4
 ASL A
 ASL A
 TAX
 LDA KY5
 BIT KY6
 BPL P%+4
 LDA #1
 BIT KY7
 BPL P%+4
 ASL A
 ASL A
 TAY
 LDA #0
 STA KY3
 STA KY4
 STA KY5
 STA KY6
 STA KY7

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 RTS                    \ Return from the subroutine

.TJ1

 LDA KLO+&3E
 BEQ noxmove
 LDA #1
 ORA KLO+&31
 ORA KLO+&C

.noxmove

 BIT KLO+&3F
 BPL P%+4
 ASL A
 ASL A
 TAX
 LDA KLO+&39
 BEQ noymove
 LDA #1
 ORA KLO+&31
 ORA KLO+&C
 EOR #&FE

.noymove

 BIT KLO+&3F
 BPL P%+4
 ASL A
 ASL A
 TAY

 LDA thiskey            \ Fetch the key pressed from thiskey in the key logger

 RTS                    \ Return from the subroutine
