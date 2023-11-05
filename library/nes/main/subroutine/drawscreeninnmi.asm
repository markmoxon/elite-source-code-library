\ ******************************************************************************
\
\       Name: DrawScreenInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Configure the NMI handler to draw the screen
\  Deep dive: Views and view types in NES Elite
\
\ ******************************************************************************

.DrawScreenInNMI

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA #0                 \ Tell the NMI handler to send nametable entries from
 STA firstNameTile      \ tile 0 onwards

 LDA #100               \ Tell the NMI handler to only clear nametable entries
 STA maxNameTileToClear \ up to tile 100 * 8 = 800 (i.e. up to the end of tile
                        \ row 24)

 LDA #37                \ Tell the NMI handler to send pattern entries from
 STA firstPattern       \ pattern 37 in the buffer

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DrawBoxEdges       \ Draw the left and right edges of the box along the
                        \ sides of the screen, drawing into the nametable buffer
                        \ for the drawing bitplane

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer

 LDA #%11000100         \ Set both bitplane flags as follows:
 STA bitplaneFlags      \
 STA bitplaneFlags+1    \   * Bit 2 set   = send tiles up to end of the buffer
                        \   * Bit 3 clear = don't clear buffers after sending
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 set   = send both pattern and nametable data
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ The NMI handler will now start sending data to the PPU
                        \ according to the above configuration, splitting the
                        \ process across multiple VBlanks if necessary

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries from the
 STA firstPattern       \ first free pattern onwards, so we don't waste time
                        \ resending the static patterns we have already sent

 RTS                    \ Return from the subroutine

