\ ******************************************************************************
\
\       Name: SetupSpaceView
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set up the NMI variables for the space view
\
\ ******************************************************************************

.SetupSpaceView

 LDA #&FF               \ Set showIconBarPointer = &FF to indicate that we
 STA showIconBarPointer \ should show the icon bar pointer

 LDA #&2C               \ Set the visible colour to cyan (&2C)
 STA visibleColour

 LDA firstFreeTile      \ Tell the NMI handler to send pattern entries from the
 STA firstPatternTile   \ first free tile onwards, so we don't waste time
                        \ resending the static tiles we have already sent

 LDA #80                \ Tell the NMI handler to only clear nametable entries
 STA maxNameTileToClear \ up to tile 80 * 8 = 640 (i.e. up to the end of tile
                        \ row 19)

 LDX #8                 \ Tell the NMI handler to send nametable entries from
 STX firstNametableTile \ tile 8 * 8 = 64 onwards (i.e. from the start of tile
                        \ row 2)

 LDA #116               \ Tell the NMI handler to send nametable entries up to
 STA lastNameTile       \ tile 116 * 8 = 800 (i.e. up to the end of tile row 28)
                        \ in bitplane 0

 RTS                    \ Return from the subroutine

