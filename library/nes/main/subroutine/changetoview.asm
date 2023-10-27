\ ******************************************************************************
\
\       Name: ChangeToView
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen and set a new view type
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of the new view
\
\ ******************************************************************************

.ChangeToView

 JSR TT66               \ Clear the screen and set the view type in QQ11 to the
                        \ value of A

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer and tell the NMI handler to send pattern
                        \ entries up to the first free tile

 JSR UpdateScreen       \ Update the screen by sending data to the PPU, either
                        \ immediately or during VBlank, depending on whether
                        \ the screen is visible

 LDA #&00               \ Set the view type in QQ11 to &00 (Space view with no
 STA QQ11               \ font loaded)

 STA QQ11a              \ Set the old view type in QQ11a to &00 (Space view with
                        \ no fonts loaded)

 STA showIconBarPointer \ Set showIconBarPointer to 0 to indicate that we should
                        \ hide the icon bar pointer

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries from the
 STA firstPattern       \ first free pattern onwards, so we don't waste time
                        \ resending the static patterns we have already sent

 LDA #80                \ Tell the NMI handler to only clear nametable entries
 STA maxNameTileToClear \ up to tile 80 * 8 = 640 (i.e. up to the end of tile
                        \ row 19)

 LDX #8                 \ Tell the NMI handler to send nametable entries from
 STX firstNametableTile \ tile 8 * 8 = 64 onwards (i.e. from the start of tile
                        \ row 2)

 RTS                    \ Return from the subroutine

