\ ******************************************************************************
\
\       Name: DrawBitplaneInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Configure the NMI to send the drawing bitplane to the PPU after
\             drawing the box edges and setting the next free tile number
\
\ ******************************************************************************

.DrawBitplaneInNMI

 LDA #%11001000         \ Set A so we set the drawing bitplane flags in
                        \ SetDrawPlaneFlags as follows:
                        \
                        \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 set   = clear buffers after sending data
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 set   = send both pattern and nametable data
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ This configures the NMI to send nametable and pattern
                        \ data for the drawing bitplane to the PPU during VBlank

                        \ Fall through into SetDrawPlaneFlags to set the
                        \ bitplane flags, draw the box edges and set the next
                        \ free tile number

