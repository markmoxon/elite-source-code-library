\ ******************************************************************************
\
\       Name: DrawMessageInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Configure the NMI to send the portion of the screen that contains
\             the in-flight message to the PPU (i.e. tile rows 22 to 24)
\
\ ******************************************************************************

.DrawMessageInNMI

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries up to the
 STA lastPattern        \ first free pattern, for both bitplanes
 STA lastPattern+1

 LDA #88                \ Tell the NMI handler to send nametable entries from
 STA firstNametableTile \ tile 88 * 8 = 704 onwards (i.e. from the start of tile
                        \ row 22)

 LDA #100               \ Tell the NMI handler to send nametable entries up to
 STA lastNameTile       \ tile 100 * 8 = 800 (i.e. up to the end of tile row 24)
 STA lastNameTile+1     \ in both bitplanes

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

 JMP WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU,
                        \ and return from the subroutine using a tail call

