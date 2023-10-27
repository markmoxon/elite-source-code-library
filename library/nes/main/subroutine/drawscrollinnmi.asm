\ ******************************************************************************
\
\       Name: DrawScrollInNMI
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Configure the NMI handler to draw the scroll text screen
\
\ ******************************************************************************

.DrawScrollInNMI

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 LDA #254               \ Tell the NMI handler to send data up to pattern 254,
 STA firstFreePattern   \ so all the patterns get updated

 LDA #%11001000         \ Set both bitplane flags as follows:
 STA bitplaneFlags      \
 STA bitplaneFlags+1    \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 set   = clear buffers after sending data
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

 RTS                    \ Return from the subroutine

