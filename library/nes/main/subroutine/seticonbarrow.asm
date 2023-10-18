\ ******************************************************************************
\
\       Name: SetIconBarRow
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set the row on which the icon bar appears, which depends on the
\             view type
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS9                Contains an RTS
\
\ ******************************************************************************

.SetIconBarRow

 LDA QQ11               \ If the view type in QQ11 is not &BA (Market Price),
 CMP #&BA               \ then jump to bpos2 to calculate the icon bar row
 BNE bpos2

 LDA iconBarType        \ If this is icon bar type 3 (Pause), jump to bpos1 to
 CMP #3                 \ hide the Inventory icon before calculating the icon
 BEQ bpos1              \ bar row

                        \ If we get here then this is the Market Price screen
                        \ and the game is not paused, so we are showing the
                        \ normal icon bar for this screen
                        \
                        \ The Market Price screen uses the normal Docked or
                        \ Flight icon bar, but with the second icon overwritten
                        \ with the Inventory icon

 JSR DrawInventoryIcon  \ Draw the inventory icon on top of the second button
                        \ in the icon bar

 JMP bpos2              \ Jump to bpos2 to calculate the icon bar row

.bpos1

                        \ If we get here then this is the Market Price screen
                        \ and we are showing the pause options on the icon bar,
                        \ so we need to hide the Inventory icon from the second
                        \ button on the icon bar, so it doesn't overwrite the
                        \ pause options
                        \
                        \ The Inventory button is in sprites 8 to 11, so we now
                        \ hide these sprites by moving them off-screen

 LDX #240               \ Hide sprites 8 to 11 by setting their y-coordinates to
 STX ySprite8           \ to 240, which is off the bottom of the screen
 STX ySprite9
 STX ySprite10
 STX ySprite11

.bpos2

 LDA #HI(20*32)         \ Set iconBarRow(1 0) = 20*32
 STA iconBarRow+1
 LDA #LO(20*32)
 STA iconBarRow

 LDA QQ11               \ If bit 7 of the view type in QQ11 is clear then there
 BPL RTS9               \ is a dashboard, so jump to RTS9 to keep this value of
                        \ iconBarRow and return from the subroutine

 LDA #HI(27*32)         \ Set iconBarRow(1 0) = 27*32
 STA iconBarRow+1       \
 LDA #LO(27*32)         \ So the icon bar is on row 20 if bit 7 of the view
 STA iconBarRow         \ number is clear (so there is a dashboard), and it's on
                        \ row 27 is bit 7 is set (so there is no dashboard)

.RTS9

 RTS                    \ Return from the subroutine

